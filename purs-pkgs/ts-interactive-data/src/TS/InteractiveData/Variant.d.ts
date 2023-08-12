import { DataUI } from "../../../../../output/DataMVC.Types";
import {
  GetType,
  GetState,
  GetMsg,
  Variant,
  AnyDataUIs,
} from "../../../../../output/TS.InteractiveData.Common";

type GetCase<D extends AnyDataUIs> = {
  [key in keyof D]: null;
};

type VariantGetDataUI<D extends AnyDataUIs> = DataUI<
  VariantMsg<GetCase<D>, GetMsg<D>>,
  Variant<GetState<D>>,
  Variant<GetType<D>>
>;

type VariantMsg<RCase, RMsg> = Variant<{
  childCaseMsg: Variant<RMsg>;
  changeCase: Variant<RCase>;
  errorMsg: string;
}>;

export const variant_: <DataUis extends AnyDataUIs>(
  initKey: keyof DataUis,
  dataUis: DataUis
) => VariantGetDataUI<DataUis>;
