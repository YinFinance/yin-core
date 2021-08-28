// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;
pragma abicoder v2;

import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.7/Denominations.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../interfaces/yang/IOracleProvider.sol";

contract OracleProvider is IOracleProvider, OwnableUpgradeable {
    using SafeMath for uint256;

    struct Oracle {
        address base;
        address quote;
        address registry;
        bool available;
        uint256 decimals;
    }

    struct InitParam {
        address base;
        address quote;
        address registry;
        uint256 decimals;
    }

    mapping(address => mapping(address => Oracle)) public override oracles;

    function initialize(InitParam[] calldata params) public initializer {
        for (uint256 i = 0; i < params.length; i++) {
            oracles[params[i].base][params[i].quote] = Oracle({
                base: params[i].base,
                quote: params[i].quote,
                registry: params[i].registry,
                decimals: params[i].decimals,
                available: true
            });
        }
        __Ownable_init();
    }

    function USDUnderlying() external pure returns (address) {
        return Denominations.USD;
    }

    function addOracle(
        address base,
        address quote,
        address registry,
        uint256 decimals
    ) external override onlyOwner {
        require(oracles[base][quote].registry == address(0), "duplicate");
        oracles[base][quote] = Oracle({
            base: base,
            quote: quote,
            registry: registry,
            decimals: decimals,
            available: true
        });

        emit AddOracle(msg.sender, base, quote, registry);
    }

    function getUSDPrice(address token)
        public
        view
        override
        returns (int256 price)
    {
        Oracle memory usdBaseOracle = oracles[token][Denominations.USD];
        if (usdBaseOracle.available == true) {
            (, price, , , ) = AggregatorV3Interface(usdBaseOracle.registry)
                .latestRoundData();
        } else {
            Oracle memory ethBaseOracle = oracles[token][Denominations.ETH];
            Oracle memory ethUSDOracle = oracles[Denominations.ETH][
                Denominations.USD
            ];
            if (ethBaseOracle.available && ethUSDOracle.available) {
                (, int256 tokenEthPrice, , , ) = AggregatorV3Interface(
                    ethBaseOracle.registry
                ).latestRoundData();

                (, int256 ethUSDPrice, , , ) = AggregatorV3Interface(
                    ethUSDOracle.registry
                ).latestRoundData();

                price = int256(
                    uint256(tokenEthPrice).div(10**ethBaseOracle.decimals).mul(
                        uint256(ethUSDPrice)
                    )
                );
            }
        }
    }

    function getPairUSDPrice(address token0, address token1)
        external
        view
        override
        returns (int256 price0, int256 price1)
    {
        price0 = getUSDPrice(token0);
        price1 = getUSDPrice(token1);
    }
}

