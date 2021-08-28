// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;

import '@openzeppelin/contracts/math/SafeMath.sol';

abstract contract LockLiquidity {
    using SafeMath for uint256;

    modifier afterLockUnsubscribe(address account) {
        require(!_isLocked || (_isLocked && block.timestamp > _locks[account]), 'locks');
        _;
    }

    function _updateLockState(uint256 __lockInSeconds, bool __isLocked) internal {
        _lockInSeconds = __lockInSeconds;
        _isLocked = __isLocked;
        emit LockState(_lockInSeconds, _isLocked);
    }

    function _updateAccountLockDurations(address account, uint256 currentTime) internal {
        if (_isLocked) {
            uint256 durationTime = currentTime.add(_lockInSeconds);
            _locks[account] = durationTime > _locks[account] ? durationTime : _locks[account];
            emit LockAccount(account, _locks[account]);
        }
    }

    function durations(address account) external view returns (uint256) {
        return _locks[account];
    }

    uint256 private _lockInSeconds;
    bool private _isLocked;
    mapping(address => uint256) private _locks;

    event LockState(uint256, bool);
    event LockAccount(address, uint256);
}
