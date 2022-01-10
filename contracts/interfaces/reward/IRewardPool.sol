// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

interface IRewardPool {
    // View
    function share(uint256 yangId) external view returns (uint256);

    function totalShares() external view returns (uint256);

    // Mutation
    function getReward() external;

    function earned(uint256 yangId) external view returns (uint256);

    function reload(address account) external;

    /// Event
    event RewardStarted(
        uint256 startTime,
        uint256 periodFinish,
        uint256 rewardRate
    );
    event RewardAdded(uint256 reward);
    event RewardUpdated(uint256 yangId, uint256 shares, uint256 totalShares);
    event RewardPaid(address account, uint256 reward);
    event RewardRateUpdated(uint256 oldRate, uint256 newRate);
    event RewardEmergencyExit(
        address owner,
        address governance,
        uint256 amount
    );
    event RewardReloadAccount(address account);
}
