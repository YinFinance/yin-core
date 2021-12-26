/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  IRewardPoolProxy,
  IRewardPoolProxyInterface,
} from "../IRewardPoolProxy";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "pool",
        type: "address",
      },
    ],
    name: "AddRewardPool",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "pool",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "ProxyReloadRewardPool",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "pool",
        type: "address",
      },
    ],
    name: "RemoveRewardPool",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "proxyReloadRewardPool",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class IRewardPoolProxy__factory {
  static readonly abi = _abi;
  static createInterface(): IRewardPoolProxyInterface {
    return new utils.Interface(_abi) as IRewardPoolProxyInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IRewardPoolProxy {
    return new Contract(address, _abi, signerOrProvider) as IRewardPoolProxy;
  }
}
