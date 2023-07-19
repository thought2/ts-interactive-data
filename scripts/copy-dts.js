import { globSync } from "glob";
import * as fs from "fs";

const srcDir = "src";
const dstDir = "output";

const files = globSync("**/*.d.ts", { cwd: srcDir });

files.forEach((srcPath) => {
  const pathSansExtension = srcPath.replace(/\.d\.ts$/, "");
  const segments = pathSansExtension.split("/");
  const pursModuleName = segments.join(".");
  const dstPath = `${pursModuleName}/index.d.ts`;

  const srcPathFinal = `${srcDir}/${srcPath}`;
  const dstPathFinal = `${dstDir}/${dstPath}`;

  console.log(`Copying ${srcPathFinal} to ${dstPathFinal}`);

  fs.copyFileSync(srcPathFinal, dstPathFinal);
});
