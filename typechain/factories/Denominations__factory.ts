/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { Denominations, DenominationsInterface } from "../Denominations";

const _abi = [
  {
    inputs: [],
    name: "ARS",
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
    inputs: [],
    name: "AUD",
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
    inputs: [],
    name: "BTC",
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
    inputs: [],
    name: "CAD",
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
    inputs: [],
    name: "CHF",
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
    inputs: [],
    name: "CNY",
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
    inputs: [],
    name: "ETH",
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
    inputs: [],
    name: "EUR",
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
    inputs: [],
    name: "GBP",
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
    inputs: [],
    name: "JPY",
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
    inputs: [],
    name: "KRW",
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
    inputs: [],
    name: "USD",
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
];

const _bytecode =
  "0x6101a4610026600b82828239805160001a60731461001957fe5b30600052607381538281f3fe73000000000000000000000000000000000000000030146080604052600436106100ae5760003560e01c806301b8b339146100b35780630c012834146100d757806319342a64146100df5780631bf6c21b146100e75780632792949d146100ef578063294a2bf2146100f7578063465bd0a3146100ff57806356ef4514146101075780638322fff21461010f578063a4a2359514610117578063f37fcc421461011f578063fd760c4914610127575b600080fd5b6100bb61012f565b604080516001600160a01b039092168252519081900360200190f35b6100bb610135565b6100bb61013a565b6100bb61013f565b6100bb610145565b6100bb61015d565b6100bb610163565b6100bb610169565b6100bb61016f565b6100bb610187565b6100bb61018c565b6100bb610192565b61033a81565b602081565b607c81565b61034881565b73bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb81565b6103d281565b61018881565b61019a81565b73eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee81565b609c81565b6102f481565b60248156fea164736f6c6343000706000a";

export class Denominations__factory extends ContractFactory {
  constructor(signer?: Signer) {
    super(_abi, _bytecode, signer);
  }

  deploy(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<Denominations> {
    return super.deploy(overrides || {}) as Promise<Denominations>;
  }
  getDeployTransaction(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  attach(address: string): Denominations {
    return super.attach(address) as Denominations;
  }
  connect(signer: Signer): Denominations__factory {
    return super.connect(signer) as Denominations__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): DenominationsInterface {
    return new utils.Interface(_abi) as DenominationsInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Denominations {
    return new Contract(address, _abi, signerOrProvider) as Denominations;
  }
}
