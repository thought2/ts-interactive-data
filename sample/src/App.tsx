import * as React from "react";
import * as ID from "../../ts-src";

const sampleDataUi = ID.string_({
  multilineInline: true,
  maxLength: 100,
});

export const App = () => {
  return (
    <div>
      <h1>React App</h1>
      <p></p>
    </div>
  );
};
