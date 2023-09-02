# ts-interactive-data

<img src="https://github.com/thought2/assets/blob/60a1704df4d623386090b884170d919e67a1161b/interactive-data/logo.svg" width="200">

Composable UIs for interactive data.

![ci](https://github.com/thought2/purescript-interactive-data/actions/workflows/ci.yaml/badge.svg)

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Discaimer ⚠](#discaimer-)
- [Live Demo](#live-demo)
- [Features](#features)
- [Use cases](#use-cases)
- [Supported types](#supported-types)
- [Getting Started](#getting-started)
  - [Installation](#installation)
  - [Minimal Example](#minimal-example)
  - [Run](#run)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Discaimer ⚠

This library is in early development and the API is not stable yet. Things may not yet work as expected.

## Live Demo

[thought2.github.io/purescript-interactive-data](https://thought2.github.io/ts-interactive-data/basic)

## Features

- **Framework agnostic**
  <br>
  _Can be embedded in any React app
- **Configurable**
  <br>
  _UIs for each data type can be customized_
- **Extensible**
  <br>
  _UIs for any custom data type can be written_
- **Data validation**
  <br>
  _Data is validated on the fly and errors are displayed_

## Use cases

Any part of a web app that need to handle user input of nested structured data. E.g:

- settings panel 
- back office tools
- user input forms

## Supported types

The following types are supported out of the box:

- `String`
- `Number`
- `Record`
- Tagged unions

## Getting Started

### Installation

```bash
npm install ts-interactive-data
```

### Minimal Example

<!-- START demoApp -->
*App.tsx:*
```tsx
import * as ID from "ts-interactive-data";
import * as React from "react";

// 1. Compose a "Data UI" for a specific type
const sampleDataUi = ID.record_({
  user: ID.record_({
    firstName: ID.string({
      multiline: false,
      maxLength: 100,
    }),
    lastName: ID.string({}),
    size: ID.number({
      min: 0,
      max: 100,
    }),
    info: ID.variant_("age", {
      age: ID.number({}),
      name: ID.string({}),
    }),
  }),
  settings: ID.record_({
    accountId: ID.string({}),
    description: ID.string({}),
  }),
});

// 2. Turn "Data UI" into an App interface
const sampleApp = ID.toApp(sampleDataUi, {
  name: "Sample",
  fullscreen: true,
});

// 3. With the `useApp` hook you can integrate the UI into any React app
export const App = () => {
  const { jsx, data } = ID.useApp(sampleApp);

  React.useEffect(() => {
    console.log("Data of new state:");
    console.log(data);
  }, [data]);

  return <div>{jsx}</div>;
};
```
<!-- END demoApp -->

We also need to create a simple html file and an index.tsx to run the web app.


<!-- START demoIndex -->
*index.tsx:*
```tsx
import * as React from "react";
import { createRoot } from "react-dom/client";
import { App } from "./App";

const container = document.getElementById("app");

if (!container) {
  throw new Error("No container");
}

const root = createRoot(container);
root.render(<App />);
```
<!-- END demoIndex -->


<!-- START demoHtml -->
*index.html:*
```html
<html>
  <head>
    <title>ts-interactive-data Demo</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <script src="./index.tsx" type="module"></script>
    <div id="app"></div>
  </body>
</html>
```
<!-- END demoHtml -->

### Run

```bash
parcel static/index.html
```
