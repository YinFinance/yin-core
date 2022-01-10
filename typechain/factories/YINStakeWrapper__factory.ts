/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type {
  YINStakeWrapper,
  YINStakeWrapperInterface,
} from "../YINStakeWrapper";

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
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "Stake",
    type: "event",
  },
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
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "UnStake",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "yangId",
        type: "uint256",
      },
    ],
    name: "balanceOf",
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
  {
    inputs: [],
    name: "totalSupply",
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
  {
    inputs: [],
    name: "yinToken",
    outputs: [
      {
        internalType: "contract IERC20",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b50600160005560e3806100246000396000f3fe6080604052348015600f57600080fd5b5060043610603c5760003560e01c806318160ddd1460415780639cc7f70814605b578063b68f3a6f14606a575b600080fd5b6047607b565b6040516052919060cd565b60405180910390f35b6047606636600460a2565b6081565b60706093565b6040516052919060b9565b60025490565b60009081526003602052604090205490565b6001546001600160a01b031681565b60006020828403121560b2578081fd5b5035919050565b6001600160a01b0391909116815260200190565b9081526020019056fea164736f6c6343000706000a";

export class YINStakeWrapper__factory extends ContractFactory {
  constructor(signer?: Signer) {
    super(_abi, _bytecode, signer);
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<YINStakeWrapper> {
    return super.deploy(overrides || {}) as Promise<YINStakeWrapper>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): YINStakeWrapper {
    return super.attach(address) as YINStakeWrapper;
  }
  connect(signer: Signer): YINStakeWrapper__factory {
    return super.connect(signer) as YINStakeWrapper__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): YINStakeWrapperInterface {
    return new utils.Interface(_abi) as YINStakeWrapperInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): YINStakeWrapper {
    return new Contract(address, _abi, signerOrProvider) as YINStakeWrapper;
  }
}
