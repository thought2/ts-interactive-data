import * as React from "react";
import { pipe } from "fp-glue";
import { DataUI } from "../../output/DataMVC.Types";
import * as ID from "../../ts-src";
import { Either } from "../../output/Data.Either";
import { NonEmptyArray } from "../../output/Data.Array.NonEmpty";
import { DataError } from "../../output/MVC.Types";
import { Maybe } from "../../output/Data.Maybe";
import { DataTree } from "../../output/InteractiveData.Core";

type Color = {
  red: number;
  green: number;
  blue: number;
};

type ColorState = Color;

type ColorMsg = Color;

const extract = (state: ColorState): Either<NonEmptyArray<DataError>, Color> =>
  ID.mkRight(state);

const init = (val: Maybe<Color>) => {
  return pipe(
    val,
    ID.matchMaybe({
      onJust: (color) => color,
      onNothing: () => ({ red: 0, green: 0, blue: 0 }),
    })
  );
};

const update = (state: ColorState) => (msg: ColorMsg) => {
  return msg;
};

const view =
  (state: ColorState) =>
  (viewCtx): DataTree<ColorMsg> => {
    return {
      actions: [],
      children: ID.noTreeChildren(),
      meta: ID.mkNothing(),
      view: ID.mkIdHtml((ctx) => <div>Hello?</div>),
    };
  };

const colorDataUi: DataUI<ColorMsg, ColorState, Color> = (ctx) => {
  return {
    name: "Color",
    extract,
    init,
    update,
    view,
  };
};
