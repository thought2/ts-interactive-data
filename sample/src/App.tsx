import * as React from "react";
import * as ID from "../../ts-src";
import { pipe } from "fp-glue";

const sampleDataUi = ID.string_({
  multilineInline: true,
  maxLength: 100,
});

const sampleApp = pipe(
  sampleDataUi,
  ID.toApp({
    name: "Sample",
    initData: "",
    fullscreen: true,
  })
);

export const App = () => {
  return (
    <div>
      <h1>React App</h1>
      <p></p>
    </div>
  );
};
