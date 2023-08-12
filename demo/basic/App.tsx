import * as ID from "../../ts-src";
import * as React from "react";
import { pipe } from "fp-glue";

// 1. Compose a "Data UI" for a specific type
const sampleDataUi = ID.record_({
  user: ID.record_({
    firstName: ID.string({
      multilineInline: false,
      maxLength: 100,
    }),
    lastName: ID.string({}),
    size: ID.number({
      min: 0,
      max: 100,
    }),
  }),
  settings: ID.record_({
    accountId: ID.string({}),
    description: ID.string({}),
  }),
});

// 2. Turn "Data UI" into an App interface
const sampleApp = pipe(
  sampleDataUi,
  ID.toApp({
    name: "Sample",
    fullscreen: true,
  })
);

// 3. With the `useApp` hook you can integrate the UI into any React app
export const App = () => {
  const { jsx, data } = ID.useApp(sampleApp);

  React.useEffect(() => {
    console.log("Data of new state:");
    console.log(data);
  }, [data]);

  return <div>{jsx}</div>;
};
