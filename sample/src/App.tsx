import * as ID from "../../ts-src";
import * as React from "react";
import { pipe } from "fp-glue";

// 1. Compose a "Data UI" for a specific type
const sampleDataUi = ID.string_({
  multilineInline: true,
  maxLength: 100,
});

// 2. Turn "Data UI" into an App interface
const sampleApp = pipe(
  sampleDataUi,
  ID.toApp({
    name: "Sample",
    initData: "hello",
    fullscreen: true,
  })
);

// 3. Use functions from the App interface inside a regular React Component
export const App = () => {
  const ui = sampleApp.ui;

  const [state, setState] = React.useState(ui.init);

  React.useEffect(() => {
    console.log("Data of new state:");
    console.log(sampleApp.extract(state));
  }, [state]);

  const reactHtml = ui.view(state);

  const handler = (msg) => () => {
    setState(ui.update(msg));
  };

  const jsx = pipe(
    reactHtml,
    ID.runReactHtml({
      handler,
    })
  );

  return (
    <div>
      <h1>React App</h1>
      <p>{jsx}</p>
    </div>
  );
};
