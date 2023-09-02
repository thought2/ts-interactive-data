import * as ID from "../../ts-src";
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
