/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type {
  IYANGDepositCallBack,
  IYANGDepositCallBackInterface,
} from "../IYANGDepositCallBack";

const _abi = [
  {
    inputs: [
      {
        internalType: "contract IERC20",
        name: "token0",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount0",
        type: "uint256",
      },
      {
        internalType: "contract IERC20",
        name: "token1",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount1",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
    ],
    name: "YANGDepositCallback",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class IYANGDepositCallBack__factory {
  static readonly abi = _abi;
  static createInterface(): IYANGDepositCallBackInterface {
    return new utils.Interface(_abi) as IYANGDepositCallBackInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IYANGDepositCallBack {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IYANGDepositCallBack;
  }
}