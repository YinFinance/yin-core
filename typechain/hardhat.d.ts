/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { ethers } from "ethers";
import {
  FactoryOptions,
  HardhatEthersHelpers as HardhatEthersHelpersBase,
} from "@nomiclabs/hardhat-ethers/types";

import * as Contracts from ".";

declare module "hardhat/types/runtime" {
  interface HardhatEthersHelpers extends HardhatEthersHelpersBase {
    getContractFactory(
      name: "Denominations",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Denominations__factory>;
    getContractFactory(
      name: "AggregatorV3Interface",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.AggregatorV3Interface__factory>;
    getContractFactory(
      name: "OwnableUpgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.OwnableUpgradeable__factory>;
    getContractFactory(
      name: "ERC165Upgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC165Upgradeable__factory>;
    getContractFactory(
      name: "IERC165Upgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC165Upgradeable__factory>;
    getContractFactory(
      name: "ERC721Upgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC721Upgradeable__factory>;
    getContractFactory(
      name: "IERC721EnumerableUpgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721EnumerableUpgradeable__factory>;
    getContractFactory(
      name: "IERC721MetadataUpgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721MetadataUpgradeable__factory>;
    getContractFactory(
      name: "IERC721ReceiverUpgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721ReceiverUpgradeable__factory>;
    getContractFactory(
      name: "IERC721Upgradeable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Upgradeable__factory>;
    getContractFactory(
      name: "IERC165",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC165__factory>;
    getContractFactory(
      name: "IERC20",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC20__factory>;
    getContractFactory(
      name: "IERC721",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721__factory>;
    getContractFactory(
      name: "IERC721Enumerable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Enumerable__factory>;
    getContractFactory(
      name: "IUniswapV3MintCallback",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3MintCallback__factory>;
    getContractFactory(
      name: "IUniswapV3SwapCallback",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3SwapCallback__factory>;
    getContractFactory(
      name: "IUniswapV3Factory",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3Factory__factory>;
    getContractFactory(
      name: "IUniswapV3Pool",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3Pool__factory>;
    getContractFactory(
      name: "IUniswapV3PoolActions",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolActions__factory>;
    getContractFactory(
      name: "IUniswapV3PoolDerivedState",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolDerivedState__factory>;
    getContractFactory(
      name: "IUniswapV3PoolEvents",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolEvents__factory>;
    getContractFactory(
      name: "IUniswapV3PoolImmutables",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolImmutables__factory>;
    getContractFactory(
      name: "IUniswapV3PoolOwnerActions",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolOwnerActions__factory>;
    getContractFactory(
      name: "IUniswapV3PoolState",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IUniswapV3PoolState__factory>;
    getContractFactory(
      name: "ISwapRouter",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ISwapRouter__factory>;
    getContractFactory(
      name: "CHIManager",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.CHIManager__factory>;
    getContractFactory(
      name: "CHIVault",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.CHIVault__factory>;
    getContractFactory(
      name: "CHIVaultDeployer",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.CHIVaultDeployer__factory>;
    getContractFactory(
      name: "ICHIDepositCallBack",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ICHIDepositCallBack__factory>;
    getContractFactory(
      name: "ICHIManager",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ICHIManager__factory>;
    getContractFactory(
      name: "ICHIVault",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ICHIVault__factory>;
    getContractFactory(
      name: "ICHIVaultDeployer",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ICHIVaultDeployer__factory>;
    getContractFactory(
      name: "IRewardPool",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IRewardPool__factory>;
    getContractFactory(
      name: "IOracleProvider",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IOracleProvider__factory>;
    getContractFactory(
      name: "IYangNFTVault",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IYangNFTVault__factory>;
    getContractFactory(
      name: "RewardPool",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.RewardPool__factory>;
    getContractFactory(
      name: "OracleProvider",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.OracleProvider__factory>;
    getContractFactory(
      name: "Timelock",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Timelock__factory>;
    getContractFactory(
      name: "LockLiquidity",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.LockLiquidity__factory>;
    getContractFactory(
      name: "YangNFTVault",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.YangNFTVault__factory>;

    // default types
    getContractFactory(
      name: string,
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<ethers.ContractFactory>;
    getContractFactory(
      abi: any[],
      bytecode: ethers.utils.BytesLike,
      signer?: ethers.Signer
    ): Promise<ethers.ContractFactory>;
  }
}