// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

interface IRewardPool {
    // View
    function shares(uint256 yangId, uint256 chiId)
        external
        view
        returns (uint256);

    function totalShares(uint256 chiId) external view returns (uint256);

    function earned(uint256 yangId, uint256 chiId)
        external
        view
        returns (uint256);

    // Mutation
    function getReward(uint256 yangId, uint256 chiId) external;

    function updateRewardFromCHI(
        uint256 yangId,
        uint256 chiId,
        uint256 _shares_,
        uint256 _totalShares_
    ) external;

    /// Event
    event RewardAdded(uint256 reward);
    event RewardUpdated(uint256 yangId, uint256 chiId);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardsDurationUpdated(uint256 newDuration);
}
