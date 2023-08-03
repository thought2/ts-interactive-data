import * as ID from "../../ts-src";
import * as React from "react";
import { pipe } from "fp-glue";
import { DataUI } from "../../output/DataMVC.Types";
import { StringMsg, StringState } from "../../output/InteractiveData";

type Expected = DataUI<
  | { type: "firstName"; value: StringMsg }
  | { type: "lastName"; value: StringMsg },
  {
    firstName: StringState;
    lastName: StringState;
  },
  {
    firstName: string;
    lastName: string;
  }
>;

// 1. Compose a "Data UI" for a specific type
const sampleDataUi = ID.record_({
  user: ID.record_({
    firstName: ID.string_({
      multilineInline: false,
      maxLength: 100,
    }),
    lastName: ID.string_({
      multilineInline: false,
      maxLength: 100,
    }),
  }),
  settings: ID.record_({
    accountId: ID.string_({
      multilineInline: false,
      maxLength: 100,
    }),
    description: ID.string_({
      multilineInline: false,
      maxLength: 100,
    }),
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

  return (
    <div>
      {jsx}
    </div>
  );
};
