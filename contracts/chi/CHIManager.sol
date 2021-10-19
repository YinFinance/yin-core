// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/cryptography/MerkleProof.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "../libraries/YANGPosition.sol";
import "../libraries/LiquidityHelper.sol";

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
    // protocol fee
    uint256 private _vaultFee;
    // stragegy provider fee
    uint256 private _providerFee;

    /// YANG position
    mapping(bytes32 => YANGPosition.Info) public positions;

    /// @dev The token ID data
    mapping(uint256 => CHIData) private _chi;

    address public v3Factory;
    address public yangNFT;
    bytes32 public merkleRoot;

    address public manager;
    address public executor;
    address public deployer;
    address public treasury;
    address public governance;

    // tickPercents for rangeSets
    mapping(address => mapping(uint256 => uint256)) public tickPercents;

    uint256 private _tempChiId;
    modifier subscripting(uint256 chiId) {
        _tempChiId = chiId;
        _;
        _tempChiId = 0;
    }

    modifier onlyYANG() {
        require(msg.sender == yangNFT, "y");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "manager");
        _;
    }

    modifier onlyProviders(bytes32[] calldata merkleProof) {
        bytes32 node = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "providers"
        );
        _;
    }

    modifier onlyWhenNotPaused(uint256 tokenId) {
        CHIData storage _chi_ = _chi[tokenId];
        require(!_chi_.config.paused, "paused");
        _;
    }

    modifier isAuthorizedForToken(uint256 tokenId) {
        require(
            _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == executor,
            "not approved"
        );
        _;
    }

    // initialize
    function initialize(
        bytes32 _merkleRoot,
        address _v3Factory,
        address _yangNFT,
        address _deployer,
        address _executor,
        address _manager,
        address _governance,
        address _treasury
    ) public initializer {
        v3Factory = _v3Factory;
        yangNFT = _yangNFT;
        merkleRoot = _merkleRoot;

        manager = _manager;
        treasury = _treasury;
        governance = _governance;
        deployer = _deployer;
        executor = _executor;

        _vaultFee = 15 * 1e4;
        _providerFee = 5 * 1e4;
        _nextId = 1;
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
            uint24 fee,
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
            _vault.feeTier(),
            _vault.totalSupply()
        );
    }

    function yang(uint256 yangId, uint256 chiId)
        external
        view
        override
        returns (uint256 shares)
    {
        YANGPosition.Info storage _position = positions.get(yangId, chiId);
        shares = _position.shares;
    }

    function config(uint256 tokenId)
        external
        view
        override
        returns (
            bool isPaused,
            bool isArchived,
            bool isEquational,
            uint256 maxUSDLimit
        )
    {
        CHIData storage _chi_ = _chi[tokenId];
        return (
            _chi_.config.paused,
            _chi_.config.archived,
            _chi_.config.equational,
            _chi_.config.maxUSDLimit
        );
    }

    // UTILITIES

    function setMerkleRoot(bytes32 _merkleRoot) external onlyManager {
        emit UpdateMerkleRoot(msg.sender, merkleRoot, _merkleRoot);

        merkleRoot = _merkleRoot;
    }

    function setVaultFee(uint256 _vaultFee_) external {
        require(_vaultFee_ < 1e6, "f");
        require(msg.sender == governance, "gov");

        emit UpdateVaultFee(msg.sender, _vaultFee, _vaultFee_);

        _vaultFee = _vaultFee_;
    }

    function setProviderFee(uint256 _providerFee_) external {
        require(_providerFee_ < 1e6, "f");
        require(_providerFee_ < _vaultFee, "PLV");
        require(msg.sender == governance, "gov");

        emit UpdateProviderFee(msg.sender, _providerFee, _providerFee_);

        _providerFee = _providerFee_;
    }

    function setDeployer(address _deployer) external onlyManager {
        emit UpdateDeployer(msg.sender, deployer, _deployer);

        deployer = _deployer;
    }

    function setExecutor(address _executor) external onlyManager {
        emit UpdateExecutor(msg.sender, executor, _executor);

        executor = _executor;
    }

    function setGovernance(address _governance) external onlyManager {
        emit UpdateGovernance(msg.sender, governance, _governance);

        governance = _governance;
    }

    function setMaxUSDLimit(uint256 tokenId, uint256 _maxUSDLimit)
        external
        isAuthorizedForToken(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        emit UpdateMaxUSDLimit(
            msg.sender,
            _chi_.config.maxUSDLimit,
            _maxUSDLimit
        );

        _chi_.config.maxUSDLimit = _maxUSDLimit;
    }

    // CHI OPERATIONS

    function mint(MintParams calldata params, bytes32[] calldata merkleProof)
        external
        override
        onlyProviders(merkleProof)
        returns (uint256 tokenId, address vault)
    {
        address uniswapPool = IUniswapV3Factory(v3Factory).getPool(
            params.token0,
            params.token1,
            params.fee
        );

        require(uniswapPool != address(0), "non-existent pool");

        vault = ICHIVaultDeployer(deployer).createVault(
            uniswapPool,
            address(this),
            _vaultFee
        );
        _mint(params.recipient, (tokenId = _nextId++));

        CHIConfig memory _config_ = CHIConfig({
            paused: false,
            archived: false,
            equational: true,
            maxUSDLimit: 0
        });

        _chi[tokenId] = CHIData({
            operator: params.recipient,
            pool: uniswapPool,
            vault: vault,
            config: _config_
        });

        emit Create(tokenId, uniswapPool, vault, _vaultFee);
    }

    function subscribeSingle(
        uint256 yangId,
        uint256 tokenId,
        bool zeroForOne,
        uint256 exactAmount,
        uint256 maxTokenAmount,
        uint256 minShares
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
        (shares, amount0, amount1) = ICHIVault(_chi_.vault).depositSingle(
            yangId,
            zeroForOne,
            exactAmount,
            maxTokenAmount,
            minShares
        );

        bytes32 positionKey = keccak256(abi.encodePacked(yangId, tokenId));
        positions[positionKey].shares = positions[positionKey].shares.add(
            shares
        );
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
        require(!_chi_.config.archived, "archived");

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
    }

    function unsubscribeSingle(
        uint256 yangId,
        uint256 tokenId,
        bool zeroForOne,
        uint256 shares,
        uint256 amountOutMin
    ) external override onlyYANG nonReentrant returns (uint256 amount) {
        CHIData storage _chi_ = _chi[tokenId];
        require(!_chi_.config.archived, "archived");

        bytes32 positionKey = keccak256(abi.encodePacked(yangId, tokenId));
        YANGPosition.Info storage _position = positions[positionKey];
        require(_position.shares >= shares, "s");

        amount = ICHIVault(_chi_.vault).withdrawSingle(
            yangId,
            zeroForOne,
            shares,
            amountOutMin,
            yangNFT
        );
        _position.shares = positions[positionKey].shares.sub(shares);
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
        uint256 amount1,
        address recipient
    ) external override {
        _verifyCallback(msg.sender);
        if (amount0 > 0) token0.safeTransferFrom(yangNFT, recipient, amount0);
        if (amount1 > 0) token1.safeTransferFrom(yangNFT, recipient, amount1);
    }

    function collectProtocol(uint256 tokenId) external override {
        require(msg.sender == executor, "executor");

        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault vault = ICHIVault(_chi_.vault);
        uint256 accruedProtocolFees0 = vault.accruedProtocolFees0();
        uint256 accruedProtocolFees1 = vault.accruedProtocolFees1();

        uint256 amount0 = accruedProtocolFees0.mul(_providerFee).div(1e6);
        uint256 amount1 = accruedProtocolFees1.mul(_providerFee).div(1e6);

        vault.collectProtocol(
            amount0,
            amount1,
            IERC721(address(this)).ownerOf(tokenId)
        );
        vault.collectProtocol(
            accruedProtocolFees0.sub(amount0),
            accruedProtocolFees1.sub(amount1),
            treasury
        );
    }

    function _addAllLiquidityToPosition(
        CHIData memory _chi_,
        uint256 amount0Total,
        uint256 amount1Total
    ) internal {
        ICHIVault vault = ICHIVault(_chi_.vault);
        if (_chi_.config.equational) {
            LiquidityHelper.addAllLiquidityEquationalToPosition(
                vault,
                vault.getRangeCount(),
                amount0Total,
                amount1Total
            );
        } else {
            LiquidityHelper.addAllLiquidityPercentsToPosition(
                vault,
                vault.getRangeCount(),
                amount0Total,
                amount1Total,
                tickPercents[_chi_.vault]
            );
        }
    }

    function _addTickPercents(address _vault, uint256[] calldata percents)
        internal
    {
        uint256 rangeCount = ICHIVault(_vault).getRangeCount();
        require(rangeCount == percents.length);

        uint256 totalPercent = 0;
        for (uint256 idx = 0; idx < rangeCount; idx++) {
            tickPercents[_vault][idx] = percents[idx];
            totalPercent = totalPercent.add(percents[idx]);
        }
        require(totalPercent == 1e6);
    }

    function addTickPercents(uint256 tokenId, uint256[] calldata percents)
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        LiquidityHelper.removeVaultAllLiquidityFromPosition(
            ICHIVault(_chi_.vault)
        );
        _addTickPercents(_chi_.vault, percents);
        _chi_.config.equational = false;

        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function addAndRemoveRanges(
        uint256 tokenId,
        RangeParams[] calldata addRanges,
        RangeParams[] calldata removeRanges
    )
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        CHIData storage _chi_ = _chi[tokenId];
        LiquidityHelper.addAndRemoveRanges(
            ICHIVault(_chi_.vault),
            addRanges,
            removeRanges
        );
        _chi_.config.equational = true;
        emit ChangeLiquidity(tokenId, _chi_.vault);
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
        LiquidityHelper.addAndRemoveRanges(
            ICHIVault(_chi_.vault),
            addRanges,
            removeRanges
        );
        _addTickPercents(_chi_.vault, percents);
        _chi_.config.equational = false;
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
        LiquidityHelper.removeVaultAllLiquidityFromPosition(vault);
        vault.addRange(tickLower, tickUpper);
        _chi_.config.equational = true;

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
        LiquidityHelper.removeVaultAllLiquidityFromPosition(vault);
        vault.removeRange(tickLower, tickUpper);
        _chi_.config.equational = true;

        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function addAllLiquidityToPosition(
        uint256 tokenId,
        uint256 amount0Total,
        uint256 amount1Total,
        bool useEvent
    )
        external
        override
        isAuthorizedForToken(tokenId)
        onlyWhenNotPaused(tokenId)
    {
        if (!useEvent) {
            CHIData storage _chi_ = _chi[tokenId];
            _addAllLiquidityToPosition(_chi_, amount0Total, amount1Total);
            emit ChangeLiquidity(tokenId, _chi_.vault);
        } else {
            emit AddAllLiquidityToPositionEvent(
                msg.sender,
                tokenId,
                amount0Total,
                amount1Total
            );
        }
    }

    function removeAllLiquidityFromPosition(
        uint256 tokenId,
        uint256 rangeIndex,
        bool useEvent
    ) external override isAuthorizedForToken(tokenId) {
        if (!useEvent) {
            CHIData storage _chi_ = _chi[tokenId];
            require(!_chi_.config.archived, "archived");
            ICHIVault(_chi_.vault).removeAllLiquidityFromPosition(rangeIndex);
            emit ChangeLiquidity(tokenId, _chi_.vault);
        } else {
            emit RemoveAllLiquidityFromPositionEvent(
                msg.sender,
                tokenId,
                rangeIndex
            );
        }
    }

    function removeLiquidityFromPosition(
        uint256 tokenId,
        uint256 rangeIndex,
        uint128 liquidity,
        bool useEvent
    ) external override isAuthorizedForToken(tokenId) {
        if (!useEvent) {
            CHIData storage _chi_ = _chi[tokenId];
            require(!_chi_.config.archived, "archived");
            ICHIVault(_chi_.vault).removeLiquidityFromPosition(
                rangeIndex,
                liquidity
            );

            emit ChangeLiquidity(tokenId, _chi_.vault);
        } else {
            emit RemoveLiquidityFromPositionEvent(
                msg.sender,
                tokenId,
                rangeIndex,
                liquidity
            );
        }
    }

    function addLiquidityToPosition(
        uint256 tokenId,
        uint256 rangeIndex,
        uint256 amount0Desired,
        uint256 amount1Desired,
        bool useEvent
    ) external override isAuthorizedForToken(tokenId) {
        if (!useEvent) {
            CHIData storage _chi_ = _chi[tokenId];
            require(!_chi_.config.archived, "archived");
            ICHIVault(_chi_.vault).addLiquidityToPosition(
                rangeIndex,
                amount0Desired,
                amount1Desired
            );
            emit ChangeLiquidity(tokenId, _chi_.vault);
        } else {
            emit AddLiquidityToPositionEvent(
                msg.sender,
                tokenId,
                rangeIndex,
                amount0Desired,
                amount1Desired
            );
        }
    }

    function pausedCHI(uint256 tokenId) external override {
        CHIData storage _chi_ = _chi[tokenId];
        require(
            _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == manager,
            "not approved"
        );

        LiquidityHelper.removeVaultAllLiquidityFromPosition(
            ICHIVault(_chi_.vault)
        );
        _chi_.config.paused = true;

        emit ChangeLiquidity(tokenId, _chi_.vault);
    }

    function unpausedCHI(uint256 tokenId) external override {
        CHIData storage _chi_ = _chi[tokenId];
        require(
            _isApprovedOrOwner(msg.sender, tokenId) || msg.sender == manager,
            "not approved"
        );
        require(!_chi_.config.archived, "archived");
        _chi_.config.paused = false;
    }

    function archivedCHI(uint256 tokenId) external override onlyManager {
        CHIData storage _chi_ = _chi[tokenId];
        require(_chi_.config.paused, "not paused");
        _chi_.config.archived = true;
    }

    function sweep(
        uint256 tokenId,
        address token,
        address to
    ) external override onlyManager {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault(_chi_.vault).sweep(token, to);

        emit Sweep(msg.sender, to, token, tokenId);
    }

    function emergencyBurn(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper
    ) external override onlyManager {
        CHIData storage _chi_ = _chi[tokenId];
        ICHIVault(_chi_.vault).emergencyBurn(tickLower, tickUpper);

        emit EmergencyBurn(msg.sender, tokenId, tickLower, tickUpper);
    }

    function swap(uint256 tokenId, ICHIVault.SwapParams memory params)
        external
        override
        isAuthorizedForToken(tokenId)
        returns (uint256 amountOut)
    {
        CHIData storage _chi_ = _chi[tokenId];
        amountOut = ICHIVault(_chi_.vault).swapPercentage(params);
        emit Swap(
            tokenId,
            params.tokenIn,
            params.tokenOut,
            params.percentage,
            amountOut
        );
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
