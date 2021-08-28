// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/yang/IOracleProvider.sol";
import "../interfaces/chi/ICHIVault.sol";
import "../interfaces/chi/ICHIManager.sol";

library OraclePriceHelper {

    using SafeMath for uint256;

    function isReachMaxUSDLimit(
        uint256 tokenId,
        address token0,
        address token1,
        address oracle,
        address chiManager,
        address chiVault
    ) internal view returns (bool)
    {
        (,,,uint256 maxUSDLimit) = ICHIManager(chiManager).config(tokenId);
        if (maxUSDLimit == 0) {
            return false;
        } else {
            (uint256 amount0, uint256 amount1) = ICHIVault(chiVault).getTotalAmounts();
            (int256 price0, int256 price1) = IOracleProvider(oracle).getPairUSDPrice(token0, token1);
            uint256 totalBalance = amount0.mul(uint256(price0)).add(amount1.mul(uint256(price1)));
            return totalBalance >= maxUSDLimit ? true : false;
        }
    }
}
