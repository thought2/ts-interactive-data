import { DataUI } from "../../../../../output/DataMVC.Types";

type GetType<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<any, any, infer T> ? T : never;
};

type GetState<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<any, infer S, any> ? S : never;
};

type GetMsg<D extends AnyDataUIs> = {
  [key in keyof D]: D[key] extends DataUI<infer M, any, any> ? M : never;
};

type GetCase<D extends AnyDataUIs> = {
  [key in keyof D]: null;
};

type GetDataUI<D extends AnyDataUIs> = DataUI<
  VariantMsg<GetCase<D>, GetMsg<D>>,
  Variant<GetState<D>>,
  Variant<GetType<D>>
>;

type VariantMsg<RCase, RMsg> = Variant<{
  childCaseMsg: Variant<RMsg>;
  changeCase: Variant<RCase>;
  errorMsg: string;
}>;

type Variant<T> = {
  [key in keyof T]: { type: key; value: T[key] };
}[keyof T];

type AnyDataUI = DataUI<any, any, any>;
type AnyDataUIs = Record<string, AnyDataUI>;

export const variant_: <DataUis extends AnyDataUIs>(
  initKey: keyof DataUis
) => (dataUis: DataUis) => GetDataUI<DataUis>;
