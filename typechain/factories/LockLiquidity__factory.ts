/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { LockLiquidity, LockLiquidityInterface } from "../LockLiquidity";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "LockAccount",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "LockSeconds",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "",
        type: "bool",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    name: "LockState",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "yangId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
    ],
    name: "durations",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

export class LockLiquidity__factory {
  static readonly abi = _abi;
  static createInterface(): LockLiquidityInterface {
    return new utils.Interface(_abi) as LockLiquidityInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): LockLiquidity {
    return new Contract(address, _abi, signerOrProvider) as LockLiquidity;
  }
}
