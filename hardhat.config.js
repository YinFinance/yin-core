require("@nomiclabs/hardhat-waffle");
require('hardhat-abi-exporter');


// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
const DEFAULT_COMPILER_SETTINGS = {
  version: '0.7.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 50,
    },
    metadata: {
      bytecodeHash: 'none',
    },
  },
}

module.exports = {
  solidity: {
    compilers: [DEFAULT_COMPILER_SETTINGS],
  },
};

