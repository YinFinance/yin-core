// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Yin is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 public maximumTotalSupply;

    // maximumTotalSupply = 100000000000000000000000000
    constructor(uint256 _maximumTotalSupply) ERC20("YIN Finance", "YIN") {
        maximumTotalSupply = _maximumTotalSupply;
    }

    function mint(address account, uint256 amount) external onlyOwner {
        require(totalSupply() <= maximumTotalSupply, "maximum minted");
        _mint(account, amount);
    }
}
