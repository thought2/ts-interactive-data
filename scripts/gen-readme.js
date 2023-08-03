import { patchAll } from "./patch-readme.js";
import * as fs from "fs";

const codeBlock = (path, lang, code) =>
  `
*${path}:*
\`\`\`${lang}\n${code.trim()}\n\`\`\`
`.trim();

const main = () => {
  const source = fs.readFileSync("./README.md", "utf8").toString();

  const demoAppSrc = fs
    .readFileSync("./demo/basic/App.tsx", "utf8")
    .toString()
    .replace(
      /import \* as ID from "[^/].*"/,
      `import * as ID from "ts-interactive-data"`
    );

  const demoIndexSrc = fs
    .readFileSync("./demo/basic/index.tsx", "utf8")
    .toString();

  const demoHtmlSrc = fs
    .readFileSync("./demo/basic/index.html", "utf8")
    .toString();

  const patchData = {
    demoApp: codeBlock("App.tsx", "tsx", demoAppSrc),
    demoIndex: codeBlock("index.tsx", "tsx", demoIndexSrc),
    demoHtml: codeBlock("index.html", "html", demoHtmlSrc),
  };

  const result = patchAll(patchData)(source);

  fs.writeFileSync("./README.md", result, "utf8");
};

main();
