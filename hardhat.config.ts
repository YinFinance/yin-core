import { task } from "hardhat/config";
import "hardhat-abi-exporter";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import "@nomiclabs/hardhat-etherscan";
import "@openzeppelin/hardhat-upgrades";

require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (args, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const DEFAULT_COMPILER_SETTINGS = {
  version: "0.7.6",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
    metadata: {
      bytecodeHash: "none",
    },
  },
};

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks: {
    hardhat: {
      forking: {
        url: `${process.env.MAINNET_API_URL}`,
      },
      allowUnlimitedContractSize: true,
      blockGasLimit: 30000000,
      timeout: 120000,
    },
    test: {
      url: `${process.env.TEST_API_URL}`,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    kovan: {
      url: `${process.env.KOVAN_API_URL}`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    optimistickovan: {
      url: `https://kovan.optimism.io`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    mumbai: {
      url: `https://rpc-mumbai.maticvigil.com/v1/${process.env.MUMBAI_ID}`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY2] : [],
    },
    polygon: {
      url: `https://rpc-mainnet.maticvigil.com/v1/${process.env.MUMBAI_ID}`,
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      gasPrice: 50000000000
    }
  },
  etherscan: {
    // For verify contract
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  solidity: {
    compilers: [DEFAULT_COMPILER_SETTINGS],
  },
  mocha: {
    timeout: 2400000
  }
};
