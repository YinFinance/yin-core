// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.7.6;
pragma abicoder v2;

import "./ICHIVault.sol";
import "./ICHIDepositCallBack.sol";

interface ICHIManager is ICHIDepositCallBack {
    struct MintParams {
        address recipient;
        address token0;
        address token1;
        uint24 fee;
    }

    struct RangeParams {
        int24 tickLower;
        int24 tickUpper;
    }

    function chi(uint256 tokenId)
        external
        view
        returns (
            address owner,
            address operator,
            address pool,
            address vault,
            uint256 accruedProtocolFees0,
            uint256 accruedProtocolFees1,
            uint256 fee,
            uint256 totalShares
        );

    function mint(MintParams calldata params, bytes32[] calldata merkleProof)
        external
        returns (uint256 tokenId, address vault);

    function subscribe(
        uint256 yangId,
        uint256 tokenId,
        uint256 amount0Desired,
        uint256 amount1Desired,
        uint256 amount0Min,
        uint256 amount1Min
    )
        external
        returns (
            uint256 shares,
            uint256 amount0,
            uint256 amount1
        );

    function unsubscribe(
        uint256 yangId,
        uint256 tokenId,
        uint256 shares,
        uint256 amount0Min,
        uint256 amount1Min
    ) external returns (uint256 amount0, uint256 amount1);

    /*function addAndRemoveRanges(*/
        /*uint256 tokenId,*/
        /*RangeParams[] calldata addRanges,*/
        /*RangeParams[] calldata removeRanges*/
    /*) external;*/

    function addAndRemoveRangesWithPercents(
        uint256 tokenId,
        RangeParams[] calldata addRanges,
        RangeParams[] calldata removeRanges,
        uint256[] calldata percents
    ) external;

    function addRange(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper
    ) external;

    function removeRange(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper
    ) external;

    function collectProtocol(
        uint256 tokenId,
        uint256 amount0,
        uint256 amount1,
        address to
    ) external;

    /*function addLiquidityToPosition(*/
        /*uint256 tokenId,*/
        /*uint256 rangeIndex,*/
        /*uint256 amount0Desired,*/
        /*uint256 amount1Desired*/
    /*) external;*/

    function addAllLiquidityToPosition(
        uint256 tokenId,
        uint256 amount0Total,
        uint256 amount1Total
    ) external;

    function addTickPercents(uint256, uint256[] calldata) external;

    /*function removeLiquidityFromPosition(*/
        /*uint256 tokenId,*/
        /*uint256 rangeIndex,*/
        /*uint128 liquidity*/
    /*) external;*/

    function removeAllLiquidityFromPosition(uint256 tokenId, uint256 rangeIndex)
        external;

    function stateOfCHI(uint256 tokenId)
        external
        view
        returns (bool isPaused, bool isArchived);

    function pausedCHI(uint256 tokenId) external;

    function unpausedCHI(uint256 tokenId) external;

    function archivedCHI(uint256 tokenId) external;

    function sweep(
        uint256 tokenId,
        address token,
        address to,
        bytes32[] calldata merkleProof
    ) external;

    function emergencyBurn(
        uint256 tokenId,
        int24 tickLower,
        int24 tickUpper,
        bytes32[] calldata merkleProof
    ) external;

    function yang(uint256 yangId, uint256 chiId)
        external
        view
        returns (uint256 shares);

    event Create(
        uint256 tokenId,
        address pool,
        address vault,
        uint256 vaultFee
    );

    event ChangeLiquidity(uint256 tokenId, address vault);
}
