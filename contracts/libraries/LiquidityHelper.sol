// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/chi/ICHIVault.sol";
import "../interfaces/chi/ICHIManager.sol";

library LiquidityHelper {
    using SafeMath for uint256;

    event AddLiquidityToPosition(uint256 idx, uint256 amount0, uint256 amount1);

    function addAllLiquidityEquationalToPosition(
        ICHIVault vault,
        uint256 rangeCount,
        uint256 amount0Total,
        uint256 amount1Total
    ) internal {
        if (rangeCount > 0) {
            uint256 divideAmount0 = amount0Total.div(rangeCount);
            uint256 divideAmount1 = amount1Total.div(rangeCount);
            for (uint256 idx = 0; idx < rangeCount - 1; idx++) {
                vault.addLiquidityToPosition(idx, divideAmount0, divideAmount1);
                emit AddLiquidityToPosition(idx, divideAmount0, divideAmount1);
            }
            vault.addLiquidityToPosition(
                rangeCount - 1,
                amount0Total.sub(divideAmount0.mul(rangeCount - 1)),
                amount1Total.sub(divideAmount1.mul(rangeCount - 1))
            );
            emit AddLiquidityToPosition(
                rangeCount - 1,
                amount0Total.sub(divideAmount0.mul(rangeCount - 1)),
                amount1Total.sub(divideAmount1.mul(rangeCount - 1))
            );
        }
    }

    function addAllLiquidityPercentsToPosition(
        ICHIVault vault,
        uint256 rangeCount,
        uint256 amount0Total,
        uint256 amount1Total,
        mapping(uint256 => uint256) storage tickPercents
    ) internal {
        uint256 percentRate = 1e6;
        uint256 amount0Accrued = 0;
        uint256 amount1Accrued = 0;
        for (uint256 idx = 0; idx < rangeCount - 1; idx++) {
            uint256 percent = tickPercents[idx];
            uint256 amount0Desired = amount0Total.mul(percent).div(percentRate);
            uint256 amount1Desired = amount1Total.mul(percent).div(percentRate);

            amount0Accrued = amount0Accrued.add(amount0Desired);
            amount1Accrued = amount1Accrued.add(amount1Desired);
            vault.addLiquidityToPosition(idx, amount0Desired, amount1Desired);
            emit AddLiquidityToPosition(idx, amount0Desired, amount1Desired);
        }
        vault.addLiquidityToPosition(
            rangeCount - 1,
            amount0Total.sub(amount0Accrued),
            amount1Total.sub(amount1Accrued)
        );
        emit AddLiquidityToPosition(
            rangeCount - 1,
            amount0Total.sub(amount0Accrued),
            amount1Total.sub(amount1Accrued)
        );
    }

    function removeVaultAllLiquidityFromPosition(ICHIVault vault) internal {
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
    }

    function addAndRemoveRanges(
        ICHIVault vault,
        ICHIManager.RangeParams[] calldata addRanges,
        ICHIManager.RangeParams[] calldata removeRanges
    ) internal {
        removeVaultAllLiquidityFromPosition(vault);
        for (uint256 i = 0; i < addRanges.length; i++) {
            vault.addRange(addRanges[i].tickLower, addRanges[i].tickUpper);
        }
        for (uint256 i = 0; i < removeRanges.length; i++) {
            vault.removeRange(
                removeRanges[i].tickLower,
                removeRanges[i].tickUpper
            );
        }
    }
}
