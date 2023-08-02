# ts-interactive-data

## Discaimer ⚠

This library is in early development and the API is not stable yet. Things may not yet work as expected.

## Getting Started

### Installation

```bash
npm install ts-interactive-data
npm install fp-glue
```

### Minimal Example

_src/App.tsx_:

<!-- START demoApp -->
```ts
import * as ID from "ts-interactive-data";
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
```
<!-- END demoApp -->

We also need to create a simple html file and an index.tsx to run the web app.

_src/index.tsx:_

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

_static/index.html:_

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

### Run

```bash
parcel static/index.html
```
