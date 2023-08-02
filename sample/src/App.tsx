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
    initData: "hello",
    fullscreen: true,
  })
);

export const App = () => {
  const ui = sampleApp.ui;
  const [state, setState] = React.useState(ui.init);

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
