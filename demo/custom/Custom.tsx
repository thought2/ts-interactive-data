import * as React from "react";
import { pipe } from "fp-glue";
import { DataUI } from "../../output/DataMVC.Types";
import * as ID from "../../ts-src";
import { Either } from "../../output/Data.Either";
import { NonEmptyArray } from "../../output/Data.Array.NonEmpty";
import { DataError } from "../../output/MVC.Types";
import { Maybe } from "../../output/Data.Maybe";
import { DataTree } from "../../output/InteractiveData.Core";

// ----------------------------------------------------------------------------
// Types
// ----------------------------------------------------------------------------

export type Color = {
  red: number;
  green: number;
  blue: number;
};

type ColorState = Color;

type ColorMsg = Color;

// ----------------------------------------------------------------------------
// Extract
// ----------------------------------------------------------------------------

const extract = (state: ColorState): Either<NonEmptyArray<DataError>, Color> =>
  ID.mkRight(state);

// ----------------------------------------------------------------------------
// Init
// ----------------------------------------------------------------------------

const black: Color = { red: 0, green: 0, blue: 0 };

const init = (val: Maybe<Color>) => {
  return pipe(
    val,
    ID.matchMaybe({
      onJust: (color) => color,
      onNothing: () => black,
    })
  );
};

// ----------------------------------------------------------------------------
// Update
// ----------------------------------------------------------------------------

const update = (msg: ColorMsg) => (state: ColorState) => {
  return msg;
};

// ----------------------------------------------------------------------------
// View
// ----------------------------------------------------------------------------

const ColorUI = ({
  onMsg,
  state,
}: {
  onMsg: (msg: ColorMsg) => () => void;
  state: ColorState;
}) => {
  const handleOnChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const valueHexStr = event.target.value;
    const valueRgb = hexToRgb(valueHexStr);
    if (!valueRgb) return;
    onMsg(valueRgb)();
  };

  const valueRgb = rgbToHex(state);

  return (
    <div>
      Select a color:
      <br />
      <input type="color" onChange={handleOnChange} value={valueRgb} />
    </div>
  );
};

// ----------------------------------------------------------------------------
// DataUI
// ----------------------------------------------------------------------------

export type ColorCfg = {
  label?: string;
};

export const color =
  (cfg: ColorCfg = {}): DataUI<ColorMsg, ColorState, Color> =>
  (ctx) => {
    return {
      name: "Color",
      extract,
      init,
      update,
      view:
        (state: ColorState) =>
        (viewCtx): DataTree<ColorMsg> => {
          return {
            text: ID.mkNothing(),
            actions: [],
            children: ID.noTreeChildren(),
            meta: ID.mkNothing(),
            view: ID.mkIdHtml((ctx) => ColorUI({ ...ctx, state })),
          };
        },
    };
  };

// ----------------------------------------------------------------------------
// Utils
// ----------------------------------------------------------------------------

const rgbToHex = ({ red, green, blue }: Color): string => {
  const componentToHex = (c: number) => {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
  };

  return (
    "#" + componentToHex(red) + componentToHex(green) + componentToHex(blue)
  );
};

const hexToRgb = (hex: string): Color | null => {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        red: parseInt(result[1], 16),
        green: parseInt(result[2], 16),
        blue: parseInt(result[3], 16),
      }
    : null;
};
