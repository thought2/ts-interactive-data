import React from "react";
import { createRoot } from "react-dom/client";
import * as ID from "../output/TS.InteractiveData.DataUI";
import { pipe } from "fp-glue";

type MyType = string;

const myDataUi = ID.dataUiString_;

const uiResult = ID.toUI({ initData: ID.notYetDefined(), name: "MyType" })(
  myDataUi
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
