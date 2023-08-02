# ts-interactive-data

coming soon!

## Getting Started

*src/App.tsx*:
<!-- START demoApp -->
```ts
import * as React from "react";
import * as ID from "ts-interactive-data";
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
```
<!-- END demoApp -->

We also need to create a simple html file and an index.tsx file to run the web app.

*src/index.tsx:*
<!-- START demoIndex -->
```ts
import * as React from "react";
import { createRoot } from "react-dom/client";
import { App } from "./App";

const container = document.getElementById("app");
const root = createRoot(container)
root.render(<App />);
```
<!-- END demoIndex -->

*static/index.html:*
<!-- START demoHtml -->
```html
<html>
  <body>
    <script src="../src/index.tsx" type="module"></script>
    <div id="app"></div>
  </body>
</html>
```
<!-- END demoHtml -->