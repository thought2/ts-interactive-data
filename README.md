# ts-interactive-data

coming soon!

## Getting Started

*src/App.tsx*:
```ts
import * as React from "react";
import * as ID from "ts-interactive-data"

const sampleDataUi = ID.string_;

export const App = () => {
  return (
    <div>
      <h1>React App</h1>
      <p>{ID.dataUi}</p>
    </div>
  );
};
```

We also need to create a simple html file and an index.tsx file to run the web app.

*src/index.tsx:*
```ts
import * as React from "react";
import { createRoot } from "react-dom/client";
import { App } from "./App";

const container = document.getElementById("app");
const root = createRoot(container)
root.render(<App />);
```

*static/index.html:*
```html
<html>
  <body>
    <script src="../src/index.tsx" type="module"></script>
    <div id="app"></div>
  </body>
</html>
```