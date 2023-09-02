import * as ID from "../../ts-src";
import * as React from "react";
import { pipe } from "fp-glue";
import * as IDCustom from "./Custom";

// 1. Compose a "Data UI" for a specific type
const sampleDataUi = IDCustom.color({});

// 2. Turn "Data UI" into an App interface
const sampleApp = ID.toApp(sampleDataUi, {
  name: "Sample",
  fullscreen: true,
  initData: { red: 2, green: 0, blue: 0 },
});

// 3. With the `useApp` hook you can integrate the UI into any React app
export const App = () => {
  const { jsx, data } = ID.useApp(sampleApp);

  React.useEffect(() => {
    console.log("Data of new state:");
    console.log(data);
  }, [data]);

  return (
    <div>
      <h1>React App</h1>
      <p>{jsx}</p>
    </div>
  );
};
