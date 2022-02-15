// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import "../interfaces/chi/ICHIManager.sol";
import "../interfaces/reward/IRewardPool.sol";
import "../interfaces/yang/IYangNFTVault.sol";

contract BoostMixIn is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public boostToken;

    uint256 private _totalSupply;
    mapping(uint256 => uint256) private _balances;

    event Stake(address account, uint256 amount);
    event UnStake(address account, uint256 amount);

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(uint256 yangId) public view returns (uint256) {
        return _balances[yangId];
    }

    function _stake(
        address account,
        uint256 yangId,
        uint256 amount
    ) internal {
        require(amount > 0, "AM0");
        _totalSupply = _totalSupply.add(amount);
        _balances[yangId] = _balances[yangId].add(amount);
        boostToken.safeTransferFrom(account, address(this), amount);
        emit Stake(account, amount);
    }

    function _unstake(
        address account,
        uint256 yangId,
        uint256 amount
    ) internal {
        require(totalSupply() >= amount && amount > 0, "AMT");
        _totalSupply = _totalSupply.sub(amount);
        _balances[yangId] = _balances[yangId].sub(amount);
        boostToken.safeTransfer(account, amount);
        emit UnStake(account, amount);
    }
}

contract RewardPool is IRewardPool, BoostMixIn, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 public rewardsToken;
    ICHIManager public chiManager;
    IYangNFTVault public yangNFT;

    uint256 public periodFinish;
    uint256 public rewardRate;
    uint256 public rewardsDuration; // seconds
    uint256 public totalReward;
    uint256 public accruedReward;
    uint256 public lastUpdateTime;
    uint256 public rewardPerShareStored;
    uint256 public startTime;
    uint256 public chiId;

    address public governance;
    address public provider;

    uint256 private _totalShares;
    mapping(uint256 => uint256) private _shares;

    mapping(uint256 => uint256) public rewards;
    mapping(uint256 => uint256) public userRewardPerSharePaid;

    constructor(
        address _rewardsToken,
        address _boostToken,
        address _yangNFT,
        address _chiManager,
        address _governance,
        address _provider,
        uint256 _rewardsDuration,
        uint256 _chiId
    ) {
        rewardsToken = IERC20(_rewardsToken);
        boostToken = IERC20(_boostToken);
        chiManager = ICHIManager(_chiManager);
        yangNFT = IYangNFTVault(_yangNFT);
        rewardsDuration = _rewardsDuration;
        governance = _governance;
        provider = _provider;
        chiId = _chiId;
    }

    /// View
    function share(uint256 yangId) public view override returns (uint256) {
        return _shares[yangId];
    }

    function totalShares() public view override returns (uint256) {
        return _totalShares;
    }

    function rewardPerShare() public view returns (uint256) {
        if (totalShares() == 0) {
            return rewardPerShareStored;
        }
        return
            rewardPerShareStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(2e18)
                    .div(totalShares())
            );
    }

    function earned(uint256 yangId) public view override returns (uint256) {
        uint256 reward = share(yangId)
            .mul(rewardPerShare().sub(userRewardPerSharePaid[yangId]))
            .div(5e18);
        if (totalSupply() > 0) {
            uint256 _totalSupply = totalSupply();
            return
                reward.add(reward.mul(balanceOf(yangId)).div(_totalSupply)).add(
                    rewards[yangId]
                );
        } else {
            return reward.add(rewards[yangId]);
        }
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function getRewardForDuration() external view returns (uint256) {
        return rewardRate.mul(rewardsDuration);
    }

    /// Operation

    function stake(uint256 amount)
        external
        checkStart
        nonReentrant
        notifyUpdateReward(msg.sender)
    {
        uint256 yangId = yangNFT.getTokenId(msg.sender);
        require(share(yangId) > 0, "shares");
        _stake(msg.sender, yangId, amount);
    }

    function withdraw(uint256 amount)
        external
        checkStart
        nonReentrant
        notifyUpdateReward(msg.sender)
    {
        uint256 yangId = yangNFT.getTokenId(msg.sender);
        _unstake(msg.sender, yangId, amount);
    }

    function getReward()
        external
        override
        nonReentrant
        checkStart
        notifyUpdateReward(msg.sender)
    {
        uint256 yangId = yangNFT.getTokenId(msg.sender);
        uint256 reward = Math.min(
            rewards[yangId],
            totalReward.sub(accruedReward)
        );

        if (reward > 0) {
            rewards[yangId] = 0;
            accruedReward = accruedReward.add(reward);
            rewardsToken.safeTransferFrom(provider, msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function reload(address account)
        external
        override
        notifyUpdateReward(account)
    {
        emit RewardReloadAccount(account);
    }

    /// Restricted

    function modifyRewardRate(uint256 _rewardRate) external onlyOwner {
        emit RewardRateUpdated(rewardRate, _rewardRate);
        rewardRate = _rewardRate;
    }

    function modifyBoostToken(address _boostToken) external onlyOwner {
        emit RewardBoostTokenUpdate(address(boostToken), _boostToken);
        boostToken = IERC20(_boostToken);
    }

    function _updateAccountShare(uint256 yangId) internal {
        uint256 accountShare = 0;
        if (yangId != 0) {
            accountShare = chiManager.yang(yangId, chiId);
            _shares[yangId] = accountShare;
        }
        (, , , , , , , uint256 totalCHIShares) = chiManager.chi(chiId);
        _totalShares = totalCHIShares;

        emit RewardUpdated(yangId, accountShare, totalCHIShares);
    }

    function startReward(
        uint256 _startTime,
        uint256 _rewardRate,
        uint256 amount
    ) external notifyUpdateReward(address(0)) onlyOwner {
        require(startTime == 0 && periodFinish == 0, "Dup");

        if (_startTime == 0) {
            lastUpdateTime = block.timestamp;
            startTime = block.timestamp;
            periodFinish = block.timestamp.add(rewardsDuration);
        } else {
            startTime = _startTime;
            lastUpdateTime = _startTime;
            periodFinish = startTime.add(rewardsDuration);
        }

        rewardRate = _rewardRate; // 5000 * 1e18 / 86400
        totalReward = amount;

        emit RewardStarted(startTime, periodFinish, rewardRate);
    }

    function emergencyExit(uint256 amount) external onlyOwner {
        require(amount <= rewardsToken.balanceOf(address(this)));
        rewardsToken.safeTransfer(governance, amount);

        emit RewardEmergencyExit(msg.sender, governance, amount);
    }

    /* ========== MODIFIERS ========== */

    modifier notifyUpdateReward(address account) {
        rewardPerShareStored = rewardPerShare();
        lastUpdateTime = lastTimeRewardApplicable();
        uint256 yangId = yangNFT.getTokenId(account);
        if (account != address(0) && yangId != 0) {
            rewards[yangId] = earned(yangId);
            userRewardPerSharePaid[yangId] = rewardPerShareStored;
        }
        _updateAccountShare(yangId);
        _;
    }

    modifier checkStart() {
        require(startTime != 0 && (block.timestamp > startTime), "not start");
        _;
    }
}
