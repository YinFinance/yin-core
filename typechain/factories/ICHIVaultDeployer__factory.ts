/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  ICHIVaultDeployer,
  ICHIVaultDeployerInterface,
} from "../ICHIVaultDeployer";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "oldCHIManager",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newCHIManager",
        type: "address",
      },
    ],
    name: "CHIManagerChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "oldOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnerChanged",
    type: "event",
  },
  {
    inputs: [],
    name: "CHIManager",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "uniswapV3pool",
        type: "address",
      },
      {
        internalType: "address",
        name: "manager",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "fee",
        type: "uint256",
      },
    ],
    name: "createVault",
    outputs: [
      {
        internalType: "address",
        name: "pool",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_manager",
        type: "address",
      },
    ],
    name: "setCHIManager",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_owner",
        type: "address",
      },
    ],
    name: "setOwner",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class ICHIVaultDeployer__factory {
  static readonly abi = _abi;
  static createInterface(): ICHIVaultDeployerInterface {
    return new utils.Interface(_abi) as ICHIVaultDeployerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): ICHIVaultDeployer {
    return new Contract(address, _abi, signerOrProvider) as ICHIVaultDeployer;
  }
}
