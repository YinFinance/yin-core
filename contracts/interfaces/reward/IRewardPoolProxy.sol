// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

interface IRewardPoolProxy {
    event AddRewardPool(uint256 chiId, address pool);
    event RemoveRewardPool(uint256 chiId, address pool);
    event ProxyReloadRewardPool(uint256 chiId, address pool, address account);

    function proxyReloadRewardPool(uint256 chiId, address account) external;
}
