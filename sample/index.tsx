import React from "react";
import { createRoot } from "react-dom/client";
import * as ID from "../ts-src";
import { pipe } from "fp-glue";

type MyType = string;

type MyType2 = { foo: string; bar: string };

const myDataUi2 = ID.dataUiRecord_({
  foo: ID.dataUiString_,
  bar: ID.dataUiString_,
});

const myDataUi = ID.dataUiString_;

const { ui } = pipe(
  myDataUi,
  ID.toUI({ name: "MyType", initData: ID.notYetDefined() })
);

const MyComponent = pipe(
  ui,
  ID.uiToReactComponent({
    onStateChange: (s) => () => console.log(s),
  })
)();

const main = () => {
  const container = document.getElementById("root");

  if (!container) throw new Error("Root element not found");

  const root = createRoot(container);
  root.render(<MyComponent />);
};

main();
