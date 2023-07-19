import React from "react";
import { createRoot } from "react-dom/client";
import * as ID from "../ts-src";
import { pipe } from "fp-glue";

//  Define types

type MyType = string;

type MyType2 = { foo: string; bar: string };

//  Define DataUI

const myDataUi2 = ID.dataUiRecord_({
  foo: ID.dataUiString_,
  bar: ID.dataUiString_,
  baz: ID.dataUiString_,
});

const myDataUi = ID.dataUiString_;

//  Convert DataUi to React component

const { ui, extract } = pipe(
  myDataUi2,
  ID.toUI({ name: "MyType", initData: ID.notYetDefined() })
);

const MyComponent = pipe(
  ui,
  ID.uiToReactComponent({
    onStateChange: (s) => () => console.log(extract(s)),
  })
)();

//  Run React app

const main = () => {
  const container = document.getElementById("root");

  if (!container) throw new Error("Root element not found");

  const root = createRoot(container);
  root.render(<MyComponent />);
};

main();
