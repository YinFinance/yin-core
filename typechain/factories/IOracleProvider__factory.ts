/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  IOracleProvider,
  IOracleProviderInterface,
} from "../IOracleProvider";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "base",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "quote",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "registry",
        type: "address",
      },
    ],
    name: "AddOracle",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "base",
        type: "address",
      },
      {
        internalType: "address",
        name: "quote",
        type: "address",
      },
      {
        internalType: "address",
        name: "registry",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "decimals",
        type: "uint256",
      },
    ],
    name: "addOracle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "token0",
        type: "address",
      },
      {
        internalType: "address",
        name: "token1",
        type: "address",
      },
    ],
    name: "getPairUSDPrice",
    outputs: [
      {
        internalType: "int256",
        name: "",
        type: "int256",
      },
      {
        internalType: "int256",
        name: "",
        type: "int256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "token",
        type: "address",
      },
    ],
    name: "getUSDPrice",
    outputs: [
      {
        internalType: "int256",
        name: "",
        type: "int256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "base",
        type: "address",
      },
      {
        internalType: "address",
        name: "quote",
        type: "address",
      },
    ],
    name: "oracles",
    outputs: [
      {
        internalType: "address",
        name: "_base",
        type: "address",
      },
      {
        internalType: "address",
        name: "_quote",
        type: "address",
      },
      {
        internalType: "address",
        name: "registry",
        type: "address",
      },
      {
        internalType: "bool",
        name: "available",
        type: "bool",
      },
      {
        internalType: "uint256",
        name: "decimals",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class IOracleProvider__factory {
  static readonly abi = _abi;
  static createInterface(): IOracleProviderInterface {
    return new utils.Interface(_abi) as IOracleProviderInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IOracleProvider {
    return new Contract(address, _abi, signerOrProvider) as IOracleProvider;
  }
}
