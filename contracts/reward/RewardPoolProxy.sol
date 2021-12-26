// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";

import "../interfaces/reward/IRewardPoolProxy.sol";
import "../interfaces/reward/IRewardPool.sol";


contract RewardPoolProxy is IRewardPoolProxy, Ownable {

    mapping(uint256 => address) private _pools;

    function addRewardPool(uint256 chiId, address pool) public onlyOwner {
        require(_pools[chiId] == address(0), "exists");
        _pools[chiId] = pool;

        emit AddRewardPool(chiId, pool);
    }

    function removeRewardPool(uint256 chiId) public onlyOwner {
        require(_pools[chiId] != address(0), "notexist");
        address pool = _pools[chiId];
        delete _pools[chiId];

        emit RemoveRewardPool(chiId, pool);
    }

    function modifyRewardPool(uint256 chiId, address pool) external onlyOwner {
        removeRewardPool(chiId);
        addRewardPool(chiId, pool);
    }

    function proxyReloadRewardPool(uint256 chiId, address account) external override {
        address pool = _pools[chiId];
        if (_pools[chiId] != address(0)) {
            IRewardPool(pool).reload(account);
            emit ProxyReloadRewardPool(chiId, pool, account);
        }
    }
}
