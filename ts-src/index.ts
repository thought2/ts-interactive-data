import * as ID from "../output/TS.InteractiveData";

type FirstArg<T extends (...args: any) => any> = Parameters<T>[0];

export type StringCfg = FirstArg<typeof ID.string_>;

type MkOptional<T extends (arg: any) => any> = T extends (
  arg: infer A
) => infer B
  ? (arg?: A) => B
  : never;

export const string_: MkOptional<typeof ID.string_> = (opts = {}) => {
  return ID.string_(opts);
};
