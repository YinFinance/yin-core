/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import { TypedEventFilter, TypedEvent, TypedListener } from "./commons";

interface IYangNFTVaultInterface extends ethers.utils.Interface {
  functions: {
    "YANGDepositCallback(address,uint256,address,uint256,address)": FunctionFragment;
    "checkMaxUSDLimit(uint256)": FunctionFragment;
    "getAmounts(uint256,uint256)": FunctionFragment;
    "getShares(uint256,uint256,uint256)": FunctionFragment;
    "getTokenId(address)": FunctionFragment;
    "mint(address)": FunctionFragment;
    "positions(uint256,uint256)": FunctionFragment;
    "setCHIManager(address)": FunctionFragment;
    "subscribe(tuple)": FunctionFragment;
    "subscribeSingle(tuple)": FunctionFragment;
    "unsubscribe(tuple)": FunctionFragment;
    "unsubscribeSingle(tuple)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "YANGDepositCallback",
    values: [string, BigNumberish, string, BigNumberish, string]
  ): string;
  encodeFunctionData(
    functionFragment: "checkMaxUSDLimit",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getAmounts",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "getShares",
    values: [BigNumberish, BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "getTokenId", values: [string]): string;
  encodeFunctionData(functionFragment: "mint", values: [string]): string;
  encodeFunctionData(
    functionFragment: "positions",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "setCHIManager",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "subscribe",
    values: [
      {
        yangId: BigNumberish;
        chiId: BigNumberish;
        amount0Desired: BigNumberish;
        amount1Desired: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      }
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "subscribeSingle",
    values: [
      {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        exactAmount: BigNumberish;
        maxTokenAmount: BigNumberish;
        minShares: BigNumberish;
      }
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "unsubscribe",
    values: [
      {
        yangId: BigNumberish;
        chiId: BigNumberish;
        shares: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      }
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "unsubscribeSingle",
    values: [
      {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        shares: BigNumberish;
        amountOutMin: BigNumberish;
      }
    ]
  ): string;

  decodeFunctionResult(
    functionFragment: "YANGDepositCallback",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "checkMaxUSDLimit",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "getAmounts", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getShares", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getTokenId", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "mint", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "positions", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setCHIManager",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "subscribe", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "subscribeSingle",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "unsubscribe",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "unsubscribeSingle",
    data: BytesLike
  ): Result;

  events: {
    "AcceptOwnerShip(address,address)": EventFragment;
    "MintYangNFT(address,uint256)": EventFragment;
    "ModifyCHIManager(address,address)": EventFragment;
    "ModifyRewardProxy(address,address)": EventFragment;
    "Subscribe(uint256,uint256,uint256)": EventFragment;
    "UnSubscribe(uint256,uint256,uint256,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "AcceptOwnerShip"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "MintYangNFT"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ModifyCHIManager"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "ModifyRewardProxy"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "Subscribe"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "UnSubscribe"): EventFragment;
}

export class IYangNFTVault extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: IYangNFTVaultInterface;

  functions: {
    YANGDepositCallback(
      token0: string,
      amount0: BigNumberish,
      token1: string,
      amount1: BigNumberish,
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    checkMaxUSDLimit(
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    getAmounts(
      chiId: BigNumberish,
      shares: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber]>;

    getShares(
      chiId: BigNumberish,
      amount0Desired: BigNumberish,
      amount1Desired: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, BigNumber]>;

    getTokenId(
      recipient: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    mint(
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    positions(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setCHIManager(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    subscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        amount0Desired: BigNumberish;
        amount1Desired: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    subscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        exactAmount: BigNumberish;
        maxTokenAmount: BigNumberish;
        minShares: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    unsubscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        shares: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    unsubscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        shares: BigNumberish;
        amountOutMin: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;
  };

  YANGDepositCallback(
    token0: string,
    amount0: BigNumberish,
    token1: string,
    amount1: BigNumberish,
    recipient: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  checkMaxUSDLimit(
    chiId: BigNumberish,
    overrides?: CallOverrides
  ): Promise<boolean>;

  getAmounts(
    chiId: BigNumberish,
    shares: BigNumberish,
    overrides?: CallOverrides
  ): Promise<[BigNumber, BigNumber]>;

  getShares(
    chiId: BigNumberish,
    amount0Desired: BigNumberish,
    amount1Desired: BigNumberish,
    overrides?: CallOverrides
  ): Promise<[BigNumber, BigNumber, BigNumber]>;

  getTokenId(recipient: string, overrides?: CallOverrides): Promise<BigNumber>;

  mint(
    recipient: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  positions(
    yangId: BigNumberish,
    chiId: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setCHIManager(
    arg0: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  subscribe(
    params: {
      yangId: BigNumberish;
      chiId: BigNumberish;
      amount0Desired: BigNumberish;
      amount1Desired: BigNumberish;
      amount0Min: BigNumberish;
      amount1Min: BigNumberish;
    },
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  subscribeSingle(
    params: {
      yangId: BigNumberish;
      chiId: BigNumberish;
      zeroForOne: boolean;
      exactAmount: BigNumberish;
      maxTokenAmount: BigNumberish;
      minShares: BigNumberish;
    },
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  unsubscribe(
    params: {
      yangId: BigNumberish;
      chiId: BigNumberish;
      shares: BigNumberish;
      amount0Min: BigNumberish;
      amount1Min: BigNumberish;
    },
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  unsubscribeSingle(
    params: {
      yangId: BigNumberish;
      chiId: BigNumberish;
      zeroForOne: boolean;
      shares: BigNumberish;
      amountOutMin: BigNumberish;
    },
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    YANGDepositCallback(
      token0: string,
      amount0: BigNumberish,
      token1: string,
      amount1: BigNumberish,
      recipient: string,
      overrides?: CallOverrides
    ): Promise<void>;

    checkMaxUSDLimit(
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;

    getAmounts(
      chiId: BigNumberish,
      shares: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber]>;

    getShares(
      chiId: BigNumberish,
      amount0Desired: BigNumberish,
      amount1Desired: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber, BigNumber, BigNumber]>;

    getTokenId(
      recipient: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    mint(recipient: string, overrides?: CallOverrides): Promise<BigNumber>;

    positions(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber] & {
        amount0: BigNumber;
        amount1: BigNumber;
        shares: BigNumber;
      }
    >;

    setCHIManager(arg0: string, overrides?: CallOverrides): Promise<void>;

    subscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        amount0Desired: BigNumberish;
        amount1Desired: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber] & {
        amount0: BigNumber;
        amount1: BigNumber;
        share: BigNumber;
      }
    >;

    subscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        exactAmount: BigNumberish;
        maxTokenAmount: BigNumberish;
        minShares: BigNumberish;
      },
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber] & {
        amount0: BigNumber;
        amount1: BigNumber;
        share: BigNumber;
      }
    >;

    unsubscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        shares: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: CallOverrides
    ): Promise<void>;

    unsubscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        shares: BigNumberish;
        amountOutMin: BigNumberish;
      },
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    AcceptOwnerShip(
      owner?: null,
      nextowner?: null
    ): TypedEventFilter<[string, string], { owner: string; nextowner: string }>;

    MintYangNFT(
      recipient?: null,
      tokenId?: null
    ): TypedEventFilter<
      [string, BigNumber],
      { recipient: string; tokenId: BigNumber }
    >;

    ModifyCHIManager(
      o?: null,
      n?: null
    ): TypedEventFilter<[string, string], { o: string; n: string }>;

    ModifyRewardProxy(
      o?: null,
      n?: null
    ): TypedEventFilter<[string, string], { o: string; n: string }>;

    Subscribe(
      yangId?: null,
      chiId?: null,
      share?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber, BigNumber],
      { yangId: BigNumber; chiId: BigNumber; share: BigNumber }
    >;

    UnSubscribe(
      yangId?: null,
      chiId?: null,
      amount0?: null,
      amount1?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber, BigNumber, BigNumber],
      {
        yangId: BigNumber;
        chiId: BigNumber;
        amount0: BigNumber;
        amount1: BigNumber;
      }
    >;
  };

  estimateGas: {
    YANGDepositCallback(
      token0: string,
      amount0: BigNumberish,
      token1: string,
      amount1: BigNumberish,
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    checkMaxUSDLimit(
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAmounts(
      chiId: BigNumberish,
      shares: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getShares(
      chiId: BigNumberish,
      amount0Desired: BigNumberish,
      amount1Desired: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getTokenId(
      recipient: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    mint(
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    positions(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setCHIManager(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    subscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        amount0Desired: BigNumberish;
        amount1Desired: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    subscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        exactAmount: BigNumberish;
        maxTokenAmount: BigNumberish;
        minShares: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    unsubscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        shares: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    unsubscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        shares: BigNumberish;
        amountOutMin: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    YANGDepositCallback(
      token0: string,
      amount0: BigNumberish,
      token1: string,
      amount1: BigNumberish,
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    checkMaxUSDLimit(
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAmounts(
      chiId: BigNumberish,
      shares: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getShares(
      chiId: BigNumberish,
      amount0Desired: BigNumberish,
      amount1Desired: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getTokenId(
      recipient: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    mint(
      recipient: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    positions(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setCHIManager(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    subscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        amount0Desired: BigNumberish;
        amount1Desired: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    subscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        exactAmount: BigNumberish;
        maxTokenAmount: BigNumberish;
        minShares: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    unsubscribe(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        shares: BigNumberish;
        amount0Min: BigNumberish;
        amount1Min: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    unsubscribeSingle(
      params: {
        yangId: BigNumberish;
        chiId: BigNumberish;
        zeroForOne: boolean;
        shares: BigNumberish;
        amountOutMin: BigNumberish;
      },
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;
  };
}
