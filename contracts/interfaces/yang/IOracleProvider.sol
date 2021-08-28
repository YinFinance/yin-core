// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

interface IOracleProvider {
    event AddOracle(
        address account,
        address base,
        address quote,
        address registry
    );

    function oracles(address base, address quote)
        external
        view
        returns (
            address _base,
            address _quote,
            address registry,
            bool available,
            uint256 decimals
        );

    function addOracle(
        address base,
        address quote,
        address registry,
        uint256 decimals
    ) external;

    function getUSDPrice(address token) external view returns (int256);

    function getPairUSDPrice(address token0, address token1)
        external
        view
        returns (int256, int256);
}
