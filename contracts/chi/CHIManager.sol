// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/cryptography/MerkleProof.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";

import "../libraries/YANGPosition.sol";
import "../interfaces/reward/IRewardPool.sol";

import "../interfaces/chi/ICHIManager.sol";
import "../interfaces/chi/ICHIVaultDeployer.sol";

contract CHIManager is
    ICHIManager,
    ReentrancyGuardUpgradeable,
    ERC721Upgradeable
{
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using YANGPosition for mapping(bytes32 => YANGPosition.Info);
    using YANGPosition for YANGPosition.Info;
    // CHI ID
    uint176 private _nextId;

    /// YANG position
    mapping(bytes32 => YANGPosition.Info) public positions;

    // CHI data
    struct CHIData {
        address operator;
        address pool;
        address vault;
        bool paused;
        bool archived;
        bool equational;
    }

    /// @dev The token ID data
    mapping(uint256 => CHIData) private _chi;

    address public manager;
    address public v3Factory;
    address public yangNFT;
    address public deployer;
    bytes32 public merkleRoot;
    uint256 public vaultFee;

    // tickPercents for rangeSets
    mapping(address => mapping(uint256 => uint256)) public tickPercents;

    uint256 private _tempChiId;
    modifier subscripting(uint256 chiId) {
        _tempChiId = chiId;
        _;
        _tempChiId = 0;
    }

    address public rewardPool;

    modifier onlyYANG() {
        require(msg.sender == address(yangNFT), "y");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "manager");
        _;
    }

    modifier onlyGovs(bytes32[] calldata merkleProof) {
        bytes32 node = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), "only govs");
        _;
    }

    modifier onlyWhenNotPaused(uint256 tokenId) {
        CHIData storage _chi_ = _chi[tokenId];
        require(!_chi_.paused, "CHI Paused");
        _;
    }

    modifier isAuthorizedForToken(uint256 tokenId) {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved");
        _;
    }

    // initialize
    function initialize(
        bytes32 _merkleRoot,
        uint176 _initId,
        uint256 _vaultFee,
        address _v3Factory,
        address _yangNFT,
        address _deployer,
        address _manager
    ) public initializer {
        manager = _manager;
        v3Factory = _v3Factory;
        yangNFT = _yangNFT;
        deployer = _deployer;
        merkleRoot = _merkleRoot;
        _nextId = _initId;
        vaultFee = _vaultFee;
        __ERC721_init("YIN Uniswap V3 Positions Manager", "CHI");
        __ReentrancyGuard_init();
    }

    // VIEW

    function chi(uint256 tokenId)
        external
        view
        override
        returns (
            address owner,
            address operator,
            address pool,
            address vault,
            uint256 accruedProtocolFees0,
            uint256 accruedProtocolFees1,
            uint256 fee,
            uint256 totalShares
        )
    {
        CHIData storage _chi_ = _chi[tokenId];
        require(_exists(tokenId), "Invalid token ID");
        ICHIVault _vault = ICHIVault(_chi_.vault);
        return (
            ownerOf(tokenId),
            _chi_.operator,
            _chi_.pool,
            _chi_.vault,
            _vault.accruedProtocolFees0(),
            _vault.accruedProtocolFees1(),
            _vault.protocolFee(),
            _vault.totalSupply()
        );
    }

    function yang(uint256 yangId, uint256 chiId)
        external
        view
        override
        returns (uint256 shares)
    {
        bytes32 key = keccak256(abi.encodePacked(yangId, chiId));
        YANGPosition.Info memory _position = positions[key];
        shares = _position.shares;
    }

    function stateOfCHI(uint256 tokenId)
        external
        view
        override
        returns (bool isPaused, bool isArchived)
    {
        CHIData storage _chi_ = _chi[tokenId];
        isPaused = _chi_.paused;
        isArchived = _chi_.archived;
    }

    // UTILITIES

    function updateMerkleRoot(bytes32 _merkleRoot) external onlyManager {
        merkleRoot = _merkleRoot;
    }

    function updateVaultFee(uint256 _vaultFee) external onlyManager {
        vaultFee = _vaultFee;
    }

    function updateRewardPool(address _rewardPool) external onlyManager {
        rewardPool = _rewardPool;
    }

    function updateDeployer(address _deployer) external onlyManager {
        deployer = _deployer;
    }

    function _updateReward(
        uint256 yangId,
        uint256 chiId,
        uint256 shares
    ) internal {
        if (rewardPool != address(0)) {
            CHIData storage _chi_ = _chi[chiId];
            IRewardPool(rewardPool).updateRewardFromCHI(
                yangId,
                chiId,
                shares,
                ICHIVault(_chi_.vault).totalSupply()
            );
        }
    }

    // CHI OPERATIONS

    function mint(MintParams calldata params, bytes32[] calldata merkleProof)
        external
        override
        onlyGovs(merkleProof)
        returns (uint256 tokenId, address vault)
    {
        address uniswapPool = IUniswapV3Factory(v3Factory).getPool(
            params.token0,
            params.token1,
            params.fee
        );

        require(uniswapPool != address(0), "Non-existent pool");

        vault = ICHIVaultDeployer(deployer).createVault(
            uniswapPool,
            address(this),
            vaultFee
        );
        _mint(params.recipient, (tokenId = _nextId++));

        _chi[tokenId] = CHIData({
            operator: params.recipient,
            pool: uniswapPool,
            vault: vault,
            paused: false,
            archived: false,
            equational: true
        });

        emit Create(tokenId, uniswapPool, vault, vaultFee);
    }

    function subscribe(
        uint256 yangId,
        uint256 tokenId,
        uint256 amount0Desired,
        uint256 amount1Desired,
        uint256 amount0Min,
        uint256 amount1Min
    )
        external
        override
        onlyYANG
        subscripting(tokenId)
        onlyWhenNotPaused(tokenId)
        nonReentrant
        returns (
            uint256 shares,
            uint256 amount0,
            uint256 amount1
        )
    {
        CHIData storage _chi_ = _chi[tokenId];
        (shares, amount0, amount1) = ICHIVault(_chi_.vault).deposit(
            yangId,
            amount0Desired,
            amount1Desired,
            amount0Min,
            amount1Min
        );

        bytes32 positionKey = keccak256(abi.encodePacked(yangId, tokenId));
        positions[positionKey].shares = positions[positionKey].shares.add(
            shares
        );

        // update rewardpool
        _updateReward(yangId, tokenId, positions[positionKey].shares);
    }

    function unsubscribe(
        uint256 yangId,
        uint256 tokenId,
        uint256 shares,
        uint256 amount0Min,
        uint256 amount1Min
    )
        external
        override
        onlyYANG
        nonReentrant
        returns (uint256 amount0, uint256 amount1)
    {
        CHIData storage _chi_ = _chi[tokenId];
        require(!_chi_.archived, "CHI Archived");

        bytes32 positionKey = keccak256(abi.encodePacked(yangId, tokenId));
        YANGPosition.Info storage _position = positions[positionKey];
        require(_position.shares >= shares, "s");

        (amount0, amount1) = ICHIVault(_chi_.vault).withdraw(
            yangId,
            shares,
            amount0Min,
            amount1Min,
            yangNFT
        );
        _position.shares = positions[positionKey].shares.sub(shares);

        // update rewardpool
        _updateReward(yangId, tokenId, _position.shares);
    }

    // CALLBACK

    function _verifyCallback(address caller) internal view {
        CHIData storage _chi_ = _chi[_tempChiId];
        require(_chi_.vault == caller, "callback fail");
    }

    function CHIDepositCallback(
        IERC20 token0,
        uint256 amount0,
        IERC20 token1,
        uint256 amount1
    ) external override {
        _verifyCallback(msg.sender);
        if (amount0 > 0) token0.transferFrom(yangNFT, msg.sender, amount0);
        if (amount1 > 0) token1.transferFrom(yangNFT, msg.sender, amount1);
    }

    function collectProtocol(
        uint256 tokenId,
        uint256 amount0,
        uint256 amount1,
        address to
    ) external override onlyManager onlyWhenNotPaused(tokenId) {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault(_chi_.vault).collectProtocol(amount0, amount1, to);
    }

    function _addAllLiquidityToPosition(
        CHIData memory _chi_,
        uint256 amount0Total,
        uint256 amount1Total
    ) internal {
        uint256 count = ICHIVault(_chi_.vault).getRangeCount();
        if (_chi_.equational) {
            if (count > 0) {
                // round down
                uint256 divideAmount0 = amount0Total.div(count);
                uint256 divideAmount1 = amount1Total.div(count);
                for (uint256 idx = 0; idx < count - 1; idx++) {
                    ICHIVault(_chi_.vault).addLiquidityToPosition(
                        idx,
                        divideAmount0,
                        divideAmount1
                    );
                }
                ICHIVault(_chi_.vault).addLiquidityToPosition(
                    count - 1,
                    amount0Total.sub(divideAmount0.mul(count - 1)),
                    amount1Total.sub(divideAmount1.mul(count - 1))
                );
            }
        } else {
            uint256 percentRate = 1e4;
            uint256 amount0Accrued = 0;
            uint256 amount1Accrued = 0;
            for (uint256 idx = 0; idx < count - 1; idx++) {
                uint256 percent = tickPercents[_chi_.vault][idx];
                uint256 amount0Desired = amount0Total.mul(percent).div(
                    percentRate
                );
                uint256 amount1Desired = amount1Total.mul(percent).div(
                    percentRate
                );

                amount0Accrued = amount0Accrued.add(amount0Desired);
                amount1Accrued = amount1Accrued.add(amount1Desired);
                ICHIVault(_chi_.vault).addLiquidityToPosition(
                    idx,
                    amount0Desired,
                    amount1Desired
                );
            }
            ICHIVault(_chi_.vault).addLiquidityToPosition(
                count - 1,
                amount0Total.sub(amount0Accrued),
                amount1Total.sub(amount1Accrued)
            );
        }
    }

    function _addTickPercents(address _vault, uint256[] calldata percents)
        internal
    {
        uint256 percentRate = 1e4;
        uint256 rangeCount = ICHIVault(_vault).getRangeCount();
        require(rangeCount == percents.length, "Invalid percents");
        uint256 totalPercent = 0;
        for (uint256 idx = 0; idx < rangeCount; idx++) {
            tickPercents[_vault][idx] = percents[idx];
            totalPercent = totalPercent.add(percents[idx]);
        }
        require(totalPercent == percentRate, "percentRate");
    }

    function addTickPercents(uint256 tokenId, uint256[] calldata percents)
        external
        override
        isAuthorizedForToken(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault vault = ICHIVault(_chi_.vault);
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
        _addTickPercents(_chi_.vault, percents);
        _chi_.equational = false;

        uint256 availableBalance0 = ICHIVault(_chi_.vault).balanceToken0();
        uint256 availableBalance1 = ICHIVault(_chi_.vault).balanceToken1();
        if (availableBalance0 > 0 || availableBalance1 > 0) {
            _addAllLiquidityToPosition(
                _chi_,
                availableBalance0,
                availableBalance1
            );
        }
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function _addAndRemoveRanges(
        address _vault,
        RangeParams[] calldata addRanges,
        RangeParams[] calldata removeRanges
    ) internal {
        for (uint256 i = 0; i < addRanges.length; i++) {
            ICHIVault(_vault).addRange(
                addRanges[i].tickLower,
                addRanges[i].tickUpper
            );
        }
        for (uint256 i = 0; i < removeRanges.length; i++) {
            ICHIVault(_vault).removeRange(
                removeRanges[i].tickLower,
                removeRanges[i].tickUpper
            );
        }
    }

    function addAndRemoveRangesWithPercents(
        uint256 tokenId,
        RangeParams[] calldata addRanges,
        RangeParams[] calldata removeRanges,
        uint256[] calldata percents
    )
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault vault = ICHIVault(_chi_.vault);
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
        _addAndRemoveRanges(_chi_.vault, addRanges, removeRanges);
        _addTickPercents(_chi_.vault, percents);
        _chi_.equational = false;

        uint256 availableBalance0 = ICHIVault(_chi_.vault).balanceToken0();
        uint256 availableBalance1 = ICHIVault(_chi_.vault).balanceToken1();
        if (availableBalance0 > 0 || availableBalance1 > 0) {
            _addAllLiquidityToPosition(
                _chi_,
                availableBalance0,
                availableBalance1
            );
        }
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function addRange(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper
    )
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault vault = ICHIVault(_chi_.vault);
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
        vault.addRange(tickLower, tickUpper);
        _chi_.equational = true;

        uint256 availableBalance0 = ICHIVault(_chi_.vault).balanceToken0();
        uint256 availableBalance1 = ICHIVault(_chi_.vault).balanceToken1();
        if (availableBalance0 > 0 || availableBalance1 > 0) {
            _addAllLiquidityToPosition(
                _chi_,
                availableBalance0,
                availableBalance1
            );
        }
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function removeRange(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper
    )
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault vault = ICHIVault(_chi_.vault);
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
        vault.removeRange(tickLower, tickUpper);
        _chi_.equational = true;

        uint256 availableBalance0 = ICHIVault(_chi_.vault).balanceToken0();
        uint256 availableBalance1 = ICHIVault(_chi_.vault).balanceToken1();
        if (availableBalance0 > 0 || availableBalance1 > 0) {
            _addAllLiquidityToPosition(
                _chi_,
                availableBalance0,
                availableBalance1
            );
        }
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function addAllLiquidityToPosition(
        uint256 tokenId,
        uint256 amount0Total,
        uint256 amount1Total
    ) public override onlyManager onlyWhenNotPaused(tokenId) {
        CHIData storage _chi_ = _chi[tokenId];
        _addAllLiquidityToPosition(_chi_, amount0Total, amount1Total);
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function removeAllLiquidityFromPosition(uint256 tokenId, uint256 rangeIndex)
        external
        override
        onlyManager
    {
        CHIData storage _chi_ = _chi[tokenId];
        require(!_chi_.archived, "CHI Archived");
        ICHIVault(_chi_.vault).removeAllLiquidityFromPosition(rangeIndex);
        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function pausedCHI(uint256 tokenId) external override {
        CHIData storage _chi_ = _chi[tokenId];
        require(
            _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == manager,
            "Not approved"
        );
        _chi_.paused = true;
    }

    function unpausedCHI(uint256 tokenId) external override {
        CHIData storage _chi_ = _chi[tokenId];
        require(
            _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == manager,
            "Not approved"
        );
        require(!_chi_.archived, "CHI archived");
        _chi_.paused = false;
    }

    function archivedCHI(uint256 tokenId) external override onlyManager {
        CHIData storage _chi_ = _chi[tokenId];
        require(_chi_.paused, "Not Paused");
        _chi_.archived = true;
    }

    function sweep(
        uint256 tokenId,
        address token,
        address to,
        bytes32[] calldata merkleProof
    ) external override onlyGovs(merkleProof) {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault(_chi_.vault).sweep(token, to);
    }

    function emergencyBurn(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper,
        bytes32[] calldata merkleProof
    ) external override onlyGovs(merkleProof) {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault(_chi_.vault).emergencyBurn(tickLower, tickUpper);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable)
        returns (string memory)
    {
        require(_exists(tokenId));
        return "";
    }

    function baseURI() public pure override returns (string memory) {}

    /// @inheritdoc IERC721Upgradeable
    function getApproved(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable)
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721Upgradeable: approved query for nonexistent token"
        );

        return _chi[tokenId].operator;
    }

    /// @dev Overrides _approve to use the operator in the position, which is packed with the position permit nonce
    function _approve(address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable)
    {
        _chi[tokenId].operator = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
}
