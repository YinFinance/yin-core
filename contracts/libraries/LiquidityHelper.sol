// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/chi/ICHIVault.sol";
import "../interfaces/chi/ICHIManager.sol";

library LiquidityHelper {
    using SafeMath for uint256;

    function addLiquidityToVault(
        ICHIVault vault,
        bool equational,
        uint256 amount0Total,
        uint256 amount1Total,
        mapping(uint256 => uint256) storage tickPercents
    ) internal {
        uint256 rangeCount = vault.getRangeCount();
        if (equational) {
            if (rangeCount > 0) {
                uint256 divideAmount0 = amount0Total.div(rangeCount);
                uint256 divideAmount1 = amount1Total.div(rangeCount);
                for (uint256 idx = 0; idx < rangeCount - 1; idx++) {
                    vault.addLiquidityToPosition(
                        idx,
                        divideAmount0,
                        divideAmount1
                    );
                }
                vault.addLiquidityToPosition(
                    rangeCount - 1,
                    amount0Total.sub(divideAmount0.mul(rangeCount - 1)),
                    amount1Total.sub(divideAmount1.mul(rangeCount - 1))
                );
            }
        } else {
            uint256 percentRate = 1e6;
            uint256 amount0Accrued = 0;
            uint256 amount1Accrued = 0;
            for (uint256 idx = 0; idx < rangeCount - 1; idx++) {
                uint256 percent = tickPercents[idx];
                uint256 amount0Desired = amount0Total.mul(percent).div(
                    percentRate
                );
                uint256 amount1Desired = amount1Total.mul(percent).div(
                    percentRate
                );

                amount0Accrued = amount0Accrued.add(amount0Desired);
                amount1Accrued = amount1Accrued.add(amount1Desired);
                vault.addLiquidityToPosition(
                    idx,
                    amount0Desired,
                    amount1Desired
                );
            }
            vault.addLiquidityToPosition(
                rangeCount - 1,
                amount0Total.sub(amount0Accrued),
                amount1Total.sub(amount1Accrued)
            );
        }
    }

    function removeLiquidityFromVault(ICHIVault vault) public {
        for (uint256 i = 0; i < vault.getRangeCount(); i++) {
            vault.removeAllLiquidityFromPosition(i);
        }
    }

    function removeRangeFromVault(
        ICHIVault vault,
        int24 tickLower,
        int24 tickUpper
    ) public {
        removeLiquidityFromVault(vault);
        vault.removeRange(tickLower, tickUpper);
    }

    function addRangeToVault(
        ICHIVault vault,
        int24 tickLower,
        int24 tickUpper
    ) public {
        removeLiquidityFromVault(vault);
        vault.addRange(tickLower, tickUpper);
    }

    function addAndRemoveRanges(
        ICHIVault vault,
        ICHIManager.RangeParams[] calldata addRanges,
        ICHIManager.RangeParams[] calldata removeRanges
    ) public {
        removeLiquidityFromVault(vault);

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

    function addAndRemoveRangesWithPercents(
        ICHIVault vault,
        ICHIManager.RangeParams[] calldata addRanges,
        ICHIManager.RangeParams[] calldata removeRanges,
        uint256[] calldata percents,
        mapping(uint256 => uint256) storage tickPercents
    ) public {
        addAndRemoveRanges(vault, addRanges, removeRanges);
        addTickPercents(vault, percents, tickPercents);
    }

    function addTickPercents(
        ICHIVault vault,
        uint256[] calldata percents,
        mapping(uint256 => uint256) storage tickPercents
    ) public {
        removeLiquidityFromVault(vault);

        uint256 totalPercent = 0;
        uint256 rangeCount = vault.getRangeCount();
        require(rangeCount == percents.length);
        for (uint256 idx = 0; idx < rangeCount; idx++) {
            tickPercents[idx] = percents[idx];
            totalPercent = totalPercent.add(percents[idx]);
        }
        require(totalPercent == 1e6);
    }
}
