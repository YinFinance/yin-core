// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import '@openzeppelin/contracts/math/Math.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';

import '@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol';

import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import '@uniswap/v3-core/contracts/libraries/TickMath.sol';
import '@uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol';

import '../libraries/YANGPosition.sol';
import '../interfaces/yang/IYangNFTVault.sol';
import '../interfaces/chi/ICHIManager.sol';
import '../interfaces/chi/ICHIVault.sol';

contract YangNFTVault is IYangNFTVault, ReentrancyGuardUpgradeable, ERC721Upgradeable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using YANGPosition for mapping(bytes32 => YANGPosition.Info);
    using YANGPosition for YANGPosition.Info;

    // owner
    address public owner;
    address private chiManager;

    modifier onlyOwner {
        require(msg.sender == owner, 'only owner');
        _;
    }

    modifier isAuthorizedForToken(uint256 tokenId) {
        require(_isApprovedOrOwner(msg.sender, tokenId), 'not approved');
        _;
    }

    // nft and Yang tokenId
    uint256 private _nextId;
    mapping(address => uint256) private _usersMap;

    // YANGPosition
    mapping(bytes32 => YANGPosition.Info) private _positions;

    // initialize
    function initialize(uint256 _initId) public initializer {
        owner = msg.sender;
        _nextId = _initId;
        __ERC721_init('YIN Asset Manager Vault', 'YANG');
        __ReentrancyGuard_init();
    }

    function setCHIManager(address _chiManager) external override onlyOwner {
        chiManager = _chiManager;
    }

    function mint(address recipient) external override returns (uint256 tokenId) {
        require(_usersMap[recipient] == 0, 'only mint once');
        // _mint function check tokenId existence
        _mint(recipient, (tokenId = _nextId++));
        _usersMap[recipient] = tokenId;

        emit MintYangNFT(recipient, tokenId);
    }

    function _deposit(
        address token0,
        uint256 amount0,
        address token1,
        uint256 amount1
    ) internal {
        if (amount0 > 0) {
            IERC20(token0).safeTransferFrom(msg.sender, address(this), amount0);
        }
        if (amount1 > 0) {
            IERC20(token1).safeTransferFrom(msg.sender, address(this), amount1);
        }
    }

    function _withdraw(
        address token0,
        uint256 amount0,
        address token1,
        uint256 amount1
    ) internal {
        if (amount0 > 0) {
            IERC20(token0).safeTransfer(msg.sender, amount0);
        }
        if (amount1 > 0) {
            IERC20(token1).safeTransfer(msg.sender, amount1);
        }
    }

    function _subscribe(
        address token0,
        address token1,
        IYangNFTVault.SubscribeParam memory params
    )
        internal
        returns (
            uint256 amount0,
            uint256 amount1,
            uint256 shares
        )
    {
        IERC20(token0).safeApprove(chiManager, params.amount0Desired);
        IERC20(token1).safeApprove(chiManager, params.amount1Desired);

        (shares, amount0, amount1) = ICHIManager(chiManager).subscribe(
            params.yangId,
            params.chiId,
            params.amount0Desired,
            params.amount1Desired,
            params.amount0Min,
            params.amount1Min
        );

        IERC20(token0).safeApprove(chiManager, 0);
        IERC20(token1).safeApprove(chiManager, 0);
    }

    function subscribe(IYangNFTVault.SubscribeParam memory params)
        external
        override
        isAuthorizedForToken(params.yangId)
        nonReentrant
        returns (
            uint256 amount0,
            uint256 amount1,
            uint256 shares
        )
    {
        require(chiManager != address(0), 'CHI');
        (, , address _pool, , , , , ) = ICHIManager(chiManager).chi(params.chiId);

        IUniswapV3Pool pool = IUniswapV3Pool(_pool);
        address token0 = pool.token0();
        address token1 = pool.token1();

        // deposit valut to yangNFT and then to chi
        _deposit(token0, params.amount0Desired, token1, params.amount1Desired);

        (amount0, amount1, shares) = _subscribe(token0, token1, params);

        YANGPosition.Info storage position = _positions.get(params.yangId, params.chiId);
        position.shares = position.shares.add(shares);

        {
            // _withdraw rest to msg.sender
            uint256 remain0 = params.amount0Desired.sub(amount0);
            uint256 remain1 = params.amount1Desired.sub(amount1);
            _withdraw(token0, remain0, token1, remain1);
        }

        emit Subscribe(params.yangId, params.chiId, shares);
    }

    function unsubscribe(IYangNFTVault.UnSubscribeParam memory params)
        external
        override
        nonReentrant
        isAuthorizedForToken(params.yangId)
    {
        require(chiManager != address(0), 'CHI');
        (, , address _pool, , , , , ) = ICHIManager(chiManager).chi(params.chiId);

        bytes32 key = keccak256(abi.encodePacked(params.yangId, params.chiId));
        require(_positions[key].shares >= params.shares, 'insufficient shares');

        (uint256 amount0, uint256 amount1) = ICHIManager(chiManager).unsubscribe(
            params.yangId,
            params.chiId,
            params.shares,
            params.amount0Min,
            params.amount1Min
        );

        IUniswapV3Pool pool = IUniswapV3Pool(_pool);
        _withdraw(pool.token0(), amount0, pool.token1(), amount1);

        YANGPosition.Info storage position = _positions.get(params.yangId, params.chiId);
        position.shares = position.shares.sub(params.shares);

        emit UnSubscribe(params.yangId, params.chiId, amount0, amount1);
    }

    // views function

    function positions(uint256 yangId, uint256 chiId)
        external
        view
        override
        returns (
            uint256 amount0,
            uint256 amount1,
            uint256 shares
        )
    {
        YANGPosition.Info memory position = _positions[keccak256(abi.encodePacked(yangId, chiId))];
        shares = position.shares;
        (uint256 _amount0, uint256 _amount1) = getAmounts(chiId, shares);
        amount0 = _amount0;
        amount1 = _amount1;
    }

    function getTokenId(address recipient) public view override returns (uint256) {
        return _usersMap[recipient];
    }

    function getCHITotalBalances(uint256 chiId) external view override returns (uint256 balance0, uint256 balance1) {
        require(chiManager != address(0), 'CHI');
        (, , , address _vault, uint256 accruedProtocolFees0, uint256 accruedProtocolFees1, , ) = ICHIManager(chiManager)
        .chi(chiId);
        IERC20 token0 = ICHIVault(_vault).token0();
        IERC20 token1 = ICHIVault(_vault).token1();
        balance0 = token0.balanceOf(_vault).sub(accruedProtocolFees0);
        balance1 = token1.balanceOf(_vault).sub(accruedProtocolFees1);
    }

    function getCHITotalAmounts(uint256 chiId) external view override returns (uint256 amount0, uint256 amount1) {
        require(chiManager != address(0), 'CHI');
        (, , , address _vault, , , , ) = ICHIManager(chiManager).chi(chiId);
        (amount0, amount1) = ICHIVault(_vault).getTotalAmounts();
    }

    function getCHIAccruedCollectFees(uint256 chiId)
        external
        view
        override
        returns (uint256 collect0, uint256 collect1)
    {
        require(chiManager != address(0), 'CHI');
        (, , , address _vault, , , , ) = ICHIManager(chiManager).chi(chiId);
        collect0 = ICHIVault(_vault).accruedCollectFees0();
        collect1 = ICHIVault(_vault).accruedCollectFees1();
    }

    function getShares(
        uint256 chiId,
        uint256 amount0Desired,
        uint256 amount1Desired
    )
        external
        view
        override
        returns (
            uint256 shares,
            uint256 amount0,
            uint256 amount1
        )
    {
        require(chiManager != address(0), 'CHI');
        (, , , address _vault, , , , uint256 _totalShares) = ICHIManager(chiManager).chi(chiId);
        (uint256 total0, uint256 total1) = ICHIVault(_vault).getTotalAmounts();

        if (_totalShares == 0) {
            // For first deposit, just use the amounts desired
            amount0 = amount0Desired;
            amount1 = amount1Desired;
            shares = Math.max(amount0, amount1);
        } else if (total0 == 0) {
            amount1 = amount1Desired;
            shares = amount1.mul(_totalShares).div(total1);
        } else if (total1 == 0) {
            amount0 = amount0Desired;
            shares = amount0.mul(_totalShares).div(total0);
        } else {
            uint256 cross = Math.min(amount0Desired.mul(total1), amount1Desired.mul(total0));
            if (cross != 0) {
                // Round up amounts
                amount0 = cross.sub(1).div(total1).add(1);
                amount1 = cross.sub(1).div(total0).add(1);
                shares = cross.mul(_totalShares).div(total0).div(total1);
            }
        }
    }

    function getAmounts(uint256 chiId, uint256 shares) public view override returns (uint256 amount0, uint256 amount1) {
        require(chiManager != address(0), 'CHI');
        (, , , address _vault, , , , uint256 _totalShares) = ICHIManager(chiManager).chi(chiId);
        if (_totalShares > 0) {
            (uint256 total0, uint256 total1) = ICHIVault(_vault).getTotalAmounts();
            amount0 = total0.mul(shares).div(_totalShares);
            amount1 = total1.mul(shares).div(_totalShares);
        }
    }

    function _amountsForLiquidity(
        IUniswapV3Pool pool,
        int24 tickLower,
        int24 tickUpper,
        uint128 liquidity
    ) internal view returns (uint256 amount0, uint256 amount1) {
        (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
        (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
            sqrtRatioX96,
            TickMath.getSqrtRatioAtTick(tickLower),
            TickMath.getSqrtRatioAtTick(tickUpper),
            liquidity
        );
    }

    function _liquidityForAmounts(
        IUniswapV3Pool pool,
        int24 tickLower,
        int24 tickUpper,
        uint256 amount0,
        uint256 amount1
    ) internal view returns (uint128 liquidity) {
        (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
        liquidity = LiquidityAmounts.getLiquidityForAmounts(
            sqrtRatioX96,
            TickMath.getSqrtRatioAtTick(tickLower),
            TickMath.getSqrtRatioAtTick(tickUpper),
            amount0,
            amount1
        );
    }

    function toUint128(uint256 x) private pure returns (uint128 y) {
        require((y = uint128(x)) == x);
    }
}
