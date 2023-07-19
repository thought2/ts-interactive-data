import * as ID from "../output/TS.InteractiveData.DataUI";
import { pipe } from "fp-glue";
import {
  DataUI,
  DataUICtx,
  Error as DataUIError,
} from "../output/InteractiveData.Core.Types";

import { Either } from "../output/Data.Either";

type GetType<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<any, any, infer T> ? T : never;
};

type GetState<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<any, infer S, any> ? S : never;
};

type GetMsg<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<infer M, any, any> ? M : never;
};

type GetDataUI<D extends AnyDataUIs> = DataUI<
  Variant<GetMsg<D>>,
  GetState<D>,
  GetType<D>
>;

type Variant<T> = {
  [key in keyof T]: { type: key; value: T[key] };
}[keyof T];

type AnyDataUI = DataUI<any, any, any>;
type AnyDataUIs = Record<string, AnyDataUI>;

export const extract =
  <DataUis extends AnyDataUIs>(dataUis: DataUis, ctx: DataUICtx) =>
  (state: GetState<DataUis>): Either<DataUIError, GetType<DataUis>> => {
    const result: Record<string, any> = {};

    for (const key in dataUis) {
      const dataUi: DataUI<unknown, unknown, unknown> = dataUis[key];
      const value: Either<DataUIError, unknown> = dataUi(ctx).extract(
        state[key]
      );
      const valueV = ID.toEitherV(value);
      switch (valueV.type) {
        case "left":
          return value as Either<DataUIError, GetType<DataUis>>;
        case "right":
          result[key as string] = valueV.value;
      }
    }

    const resultV = ID.fromEitherV({ type: "right", value: result });

    return resultV as Either<DataUIError, GetType<DataUis>>;
  };

const update =
  <DataUis extends AnyDataUIs>(dataUis: DataUis, ctx: DataUICtx) =>
  (action: Variant<GetMsg<DataUis>>) =>
  (st: GetState<DataUis>): GetState<DataUis> => {
    const key = action.type;
    const dataUi = dataUis[key](ctx);
    const oldSubState = st[key];
    const newSubState = pipe(oldSubState, dataUi.update(action.value));
    const newState = { ...st, [key]: newSubState };
    return newState;
  };

const init =
  <DataUis extends AnyDataUIs>(dataUis: DataUis, ctx: DataUICtx) =>
  (data: Either<DataUIError, GetType<DataUis>>): GetState<DataUis> => {
    return 1 as any;
  };

const view =
  <DataUis extends AnyDataUIs>(dataUis: DataUis, ctx: DataUICtx) =>
  (state: GetState<DataUis>): TBD => {
    return 1 as any;
  };

export const dataUiRecord_ =
  <DataUis extends AnyDataUIs>(dataUis: DataUis): GetDataUI<DataUis> =>
  (ctx) => {
    return {
      name: "Record",
      extract: extract(dataUis, ctx),
      init: init(dataUis, ctx),
      update: update(dataUis, ctx),
      view: view(dataUis, ctx),
    };
  };

type TBD = any;
