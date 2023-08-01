"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const react_1 = __importDefault(require("react"));
const client_1 = require("react-dom/client");
const ID = __importStar(require("../ts-src"));
const fp_glue_1 = require("fp-glue");
//  Define DataUI
const myDataUi2 = ID.dataUiRecord_({
    foo: ID.dataUiString_,
    bar: ID.dataUiString_,
    baz: ID.dataUiString_,
});
const myDataUi = ID.dataUiString_;
//  Convert DataUi to React component
const { ui, extract } = (0, fp_glue_1.pipe)(myDataUi2, ID.toUI({ name: "MyType", initData: ID.notYetDefined() }));
const MyComponent = (0, fp_glue_1.pipe)(ui, ID.uiToReactComponent({
    onStateChange: (s) => () => console.log(extract(s)),
}))();
//  Run React app
const main = () => {
    const container = document.getElementById("root");
    if (!container)
        throw new Error("Root element not found");
    const root = (0, client_1.createRoot)(container);
    root.render(<MyComponent />);
};
main();
