import { patchAll } from "./patch-readme.js";
import * as fs from "fs";

const codeBlock = (lang, code) => `\`\`\`${lang}\n${code.trim()}\n\`\`\``;

const main = () => {
  const source = fs.readFileSync("./README.md", "utf8").toString();

  const demoAppSrc = fs
    .readFileSync("./sample/src/App.tsx", "utf8")
    .toString()
    .replace(
      `import * as ID from "../../ts-src"`,
      `import * as ID from "ts-interactive-data"`
    );

  const demoIndexSrc = fs
    .readFileSync("./sample/src/index.tsx", "utf8")
    .toString();

  const demoHtmlSrc = fs
    .readFileSync("./sample/static/index.html", "utf8")
    .toString();

  const patchData = {
    demoApp: codeBlock("ts", demoAppSrc),
    demoIndex: codeBlock("ts", demoIndexSrc),
    demoHtml: codeBlock("html", demoHtmlSrc),
  };

  const result = patchAll(patchData)(source);

  fs.writeFileSync("./README.md", result, "utf8");
};

main();
