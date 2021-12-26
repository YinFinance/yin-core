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

contract YINStakeWrapper is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public yinToken;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    event Deposit(address account, uint256 amount);
    event Withdraw(address account, uint256 amount);

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake(uint256 amount) public virtual nonReentrant {
        require(amount > 0, "AM0");
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        yinToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public virtual nonReentrant {
        require(totalSupply() >= amount && amount > 0, "AMT");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        yinToken.safeTransfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);
    }
}

contract RewardPool is IRewardPool, YINStakeWrapper, Ownable {
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

    uint256 private _totalShares;
    mapping(address => uint256) private _shares;

    mapping(address => uint256) public rewards;
    mapping(address => uint256) public userRewardPerSharePaid;

    constructor(
        address _rewardsToken,
        address _yangNFT,
        address _chiManager,
        uint256 _rewardsDuration,
        uint256 _chiId
    ) {
        yinToken = IERC20(_rewardsToken);
        rewardsToken = IERC20(_rewardsToken);
        chiManager = ICHIManager(_chiManager);
        yangNFT = IYangNFTVault(_yangNFT);
        rewardsDuration = _rewardsDuration;
        chiId = _chiId;
    }

    /// View
    function share(address account) public view override returns (uint256) {
        return _shares[account];
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

    function earned(address account) public view override returns (uint256) {
        uint256 reward = share(account)
            .mul(rewardPerShare().sub(userRewardPerSharePaid[account]))
            .div(5e18)
            .add(rewards[account]);
        if (totalSupply() > 0) {
            uint256 _totalSupply = totalSupply();
            return
                reward
                    .add(reward.mul(balanceOf(account)).div(_totalSupply))
                    .add(rewards[account]);
        } else {
            return reward.add(rewards[account]);
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
        public
        override
        checkStart
        notifyUpdateReward(msg.sender)
    {
        require(share(msg.sender) > 0, "shares");
        super.stake(amount);
    }

    function withdraw(uint256 amount)
        public
        override
        checkStart
        notifyUpdateReward(msg.sender)
    {
        super.withdraw(amount);
    }

    function getReward()
        public
        override
        nonReentrant
        checkStart
        notifyUpdateReward(msg.sender)
    {
        uint256 reward = earned(msg.sender);
        require(totalReward >= accruedReward.add(reward), "MAX");

        if (reward > 0) {
            rewards[msg.sender] = 0;
            accruedReward = accruedReward.add(reward);
            rewardsToken.safeTransfer(msg.sender, reward);
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

    function addRewards(address _rewardsToken, uint256 amount)
        public
        nonReentrant
    {
        require(amount > 0, "AM0");
        IERC20(_rewardsToken).safeTransferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (address(rewardsToken) == _rewardsToken) {
            totalReward = totalReward.add(amount);
            emit RewardAdded(amount);
        }
    }

    function modifyRewardRate(uint256 _rewardRate) external onlyOwner {
        emit RewardRateUpdated(rewardRate, _rewardRate);
        rewardRate = _rewardRate;
    }

    function _updateAccountShare(address account) internal {
        uint256 accountShare = 0;
        uint256 yangId = yangNFT.getTokenId(account);
        if (account != address(0) && yangId != 0) {
            accountShare = chiManager.yang(yangId, chiId);
            _shares[account] = accountShare;
        }
        (, , , , , , , uint256 totalCHIShares) = chiManager.chi(chiId);
        _totalShares = totalCHIShares;

        emit RewardUpdated(account, accountShare, totalCHIShares);
    }

    function startReward(
        uint256 _startTime,
        uint256 _rewardRate,
        uint256 amount
    ) external notifyUpdateReward(address(0)) onlyOwner {
        require(startTime == 0 && periodFinish == 0, "Dup");

        if (_startTime == 0) {
            startTime = block.timestamp;
            periodFinish = block.timestamp.add(rewardsDuration);
        } else {
            startTime = _startTime;
            periodFinish = startTime.add(rewardsDuration);
        }

        rewardRate = _rewardRate; // 5000 * 1e18 / 86400

        emit RewardStarted(startTime, periodFinish, rewardRate);

        if (amount > 0 && rewardsToken.balanceOf(msg.sender) >= amount) {
            addRewards(address(rewardsToken), amount);
        }
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
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerSharePaid[account] = rewardPerShareStored;
        }
        _updateAccountShare(account);
        _;
    }

    modifier checkStart() {
        require(startTime != 0 && (block.timestamp > startTime), "not start");
        _;
    }
}
