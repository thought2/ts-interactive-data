import { patchAll } from "./patch-readme";

const codeBlock = (code) => `\`\`\`ts\n${code}\n\`\`\``;

const main = () => {
  const source = fs.readFileSync("./README.md", "utf8").toString();

  const demoAppSrc = fs
    .readFileSync("./sample/src/App.tsx", "utf8")
    .toString()
    .replace(
      `import * as ID from "../../ts-src"`,
      `import * as ID from "ts-interactive-data"`
    );

  const patchData = {
    demoApp: codeBlock(demoAppSrc),
  };

  const result = patchAll(patchData)(source);

  fs.writeFileSync("./README.md", result, "utf8");
};

main();
