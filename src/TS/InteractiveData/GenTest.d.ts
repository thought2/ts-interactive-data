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

export const dataUiRecord_: (cfg: {}) => <DataUis extends AnyDataUIs>(
  dataUis: DataUis
) => GetDataUI<DataUis>;
