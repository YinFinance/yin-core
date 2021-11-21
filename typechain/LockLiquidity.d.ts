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
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface LockLiquidityInterface extends ethers.utils.Interface {
  functions: {
    "durations(uint256,uint256)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "durations",
    values: [BigNumberish, BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "durations", data: BytesLike): Result;

  events: {
    "LockAccount(uint256,uint256,uint256)": EventFragment;
    "LockSeconds(uint256)": EventFragment;
    "LockState(uint256,bool,bool)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "LockAccount"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "LockSeconds"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "LockState"): EventFragment;
}

export type LockAccountEvent = TypedEvent<
  [BigNumber, BigNumber, BigNumber] & {
    arg0: BigNumber;
    arg1: BigNumber;
    arg2: BigNumber;
  }
>;

export type LockSecondsEvent = TypedEvent<[BigNumber] & { arg0: BigNumber }>;

export type LockStateEvent = TypedEvent<
  [BigNumber, boolean, boolean] & {
    arg0: BigNumber;
    arg1: boolean;
    arg2: boolean;
  }
>;

export class LockLiquidity extends BaseContract {
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

  interface: LockLiquidityInterface;

  functions: {
    durations(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;
  };

  durations(
    yangId: BigNumberish,
    chiId: BigNumberish,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  callStatic: {
    durations(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  filters: {
    "LockAccount(uint256,uint256,uint256)"(
      undefined?: null,
      undefined?: null,
      undefined?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber, BigNumber],
      { arg0: BigNumber; arg1: BigNumber; arg2: BigNumber }
    >;

    LockAccount(
      undefined?: null,
      undefined?: null,
      undefined?: null
    ): TypedEventFilter<
      [BigNumber, BigNumber, BigNumber],
      { arg0: BigNumber; arg1: BigNumber; arg2: BigNumber }
    >;

    "LockSeconds(uint256)"(
      undefined?: null
    ): TypedEventFilter<[BigNumber], { arg0: BigNumber }>;

    LockSeconds(
      undefined?: null
    ): TypedEventFilter<[BigNumber], { arg0: BigNumber }>;

    "LockState(uint256,bool,bool)"(
      undefined?: null,
      undefined?: null,
      undefined?: null
    ): TypedEventFilter<
      [BigNumber, boolean, boolean],
      { arg0: BigNumber; arg1: boolean; arg2: boolean }
    >;

    LockState(
      undefined?: null,
      undefined?: null,
      undefined?: null
    ): TypedEventFilter<
      [BigNumber, boolean, boolean],
      { arg0: BigNumber; arg1: boolean; arg2: boolean }
    >;
  };

  estimateGas: {
    durations(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    durations(
      yangId: BigNumberish,
      chiId: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
