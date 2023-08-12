import { DataUI } from "../../../../../output/DataMVC.Types";
import {
  GetType,
  GetState,
  GetMsg,
  Variant,
  AnyDataUIs,
} from "../../../../../output/TS.InteractiveData.Common";

type RecordGetDataUI<D extends AnyDataUIs> = DataUI<
  Variant<GetMsg<D>>,
  GetState<D>,
  GetType<D>
>;

export const record_: <DataUis extends AnyDataUIs>(
  dataUis: DataUis
) => RecordGetDataUI<DataUis>;
