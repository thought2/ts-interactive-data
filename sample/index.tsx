import React from "react";
import { createRoot } from "react-dom/client";
import * as ID from "../ts-src";
import { pipe } from "fp-glue";
import {
  DataUI,
  Error as DataUIError,
} from "../output/InteractiveData.Core.Types";

import { Either, either } from "../output/Data.Either";

type MyType = string;

type MyType2 = { foo: string; bar: string };

const myDataUi2 = ID.dataUiRecord_({
  foo: ID.dataUiString_,
  bar: ID.dataUiString_,
});

const myDataUi = ID.dataUiString_;

const uiResult = pipe(
  myDataUi,
  ID.toUI({ initData: ID.notYetDefined(), name: "MyType" })
);

const ui = uiResult.ui;

const MyComponent = pipe(
  ui,
  ID.uiToReactComponent({
    onStateChange: (s) => () => console.log(s),
  })
)();

const MyComponent2 = MyComponent as any;

const main = () => {
  const container = document.getElementById("root");

  if (!container) throw new Error("Root element not found");

  const root = createRoot(container);
  root.render(<MyComponent2 />);
};

main();
