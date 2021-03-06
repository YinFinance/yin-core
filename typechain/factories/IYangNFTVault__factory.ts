/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IYangNFTVault, IYangNFTVaultInterface } from "../IYangNFTVault";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "nextowner",
        type: "address",
      },
    ],
    name: "AcceptOwnerShip",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    name: "MintYangNFT",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "o",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "n",
        type: "address",
      },
    ],
    name: "ModifyCHIManager",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "o",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "n",
        type: "address",
      },
    ],
    name: "ModifyOracleRegistry",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "o",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "n",
        type: "address",
      },
    ],
    name: "ModifyRewardProxy",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "yangId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "share",
        type: "uint256",
      },
    ],
    name: "Subscribe",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "yangId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount0",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount1",
        type: "uint256",
      },
    ],
    name: "UnSubscribe",
    type: "event",
  },
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
  {
    inputs: [
      {
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
    ],
    name: "checkMaxUSDLimit",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "shares",
        type: "uint256",
      },
    ],
    name: "getAmounts",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
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
    inputs: [
      {
        internalType: "uint256",
        name: "chiId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount0Desired",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount1Desired",
        type: "uint256",
      },
    ],
    name: "getShares",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
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
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
    ],
    name: "getTokenId",
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
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
    ],
    name: "mint",
    outputs: [
      {
        internalType: "uint256",
        name: "tokenId",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
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
    name: "positions",
    outputs: [
      {
        internalType: "uint256",
        name: "amount0",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount1",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "shares",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
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
        components: [
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
          {
            internalType: "uint256",
            name: "amount0Desired",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amount1Desired",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amount0Min",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amount1Min",
            type: "uint256",
          },
        ],
        internalType: "struct IYangNFTVault.SubscribeParam",
        name: "params",
        type: "tuple",
      },
    ],
    name: "subscribe",
    outputs: [
      {
        internalType: "uint256",
        name: "amount0",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount1",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "share",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
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
          {
            internalType: "bool",
            name: "zeroForOne",
            type: "bool",
          },
          {
            internalType: "uint256",
            name: "exactAmount",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "maxTokenAmount",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "minShares",
            type: "uint256",
          },
        ],
        internalType: "struct IYangNFTVault.SubscribeSingleParam",
        name: "params",
        type: "tuple",
      },
    ],
    name: "subscribeSingle",
    outputs: [
      {
        internalType: "uint256",
        name: "amount0",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "amount1",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "share",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
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
          {
            internalType: "uint256",
            name: "shares",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amount0Min",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amount1Min",
            type: "uint256",
          },
        ],
        internalType: "struct IYangNFTVault.UnSubscribeParam",
        name: "params",
        type: "tuple",
      },
    ],
    name: "unsubscribe",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
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
          {
            internalType: "bool",
            name: "zeroForOne",
            type: "bool",
          },
          {
            internalType: "uint256",
            name: "shares",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "amountOutMin",
            type: "uint256",
          },
        ],
        internalType: "struct IYangNFTVault.UnSubscribeSingleParam",
        name: "params",
        type: "tuple",
      },
    ],
    name: "unsubscribeSingle",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

export class IYangNFTVault__factory {
  static readonly abi = _abi;
  static createInterface(): IYangNFTVaultInterface {
    return new utils.Interface(_abi) as IYangNFTVaultInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IYangNFTVault {
    return new Contract(address, _abi, signerOrProvider) as IYangNFTVault;
  }
}
