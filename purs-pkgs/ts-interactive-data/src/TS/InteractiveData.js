import * as React from "react";

export const useState = (init) => {
  const [state, setState] = React.useState(init);
  return { state, setState };
};
