import * as fs from "fs";
import * as path from "path";
import {
  EXPORT_PRESETS_CFG_PATH,
  VERSION_TXT_PATH,
  VERSION_GD_PATH
} from "./paths";

export function syncVersion() {
  const version = fs.readFileSync(VERSION_TXT_PATH, {
    encoding: 'utf-8'
  }).trim();
  console.log(
    `Setting version in ${path.basename(EXPORT_PRESETS_CFG_PATH)} to ` +
    `value in ${path.basename(VERSION_TXT_PATH)} (${version}).`
  );
  const exportPresets = fs.readFileSync(EXPORT_PRESETS_CFG_PATH, {
    encoding: 'utf-8'
  }).replace(
    /application\/(short_|file_|product_)?version=".+"$/gm,
    `application/$1version="${version}"`
  );
  fs.writeFileSync(EXPORT_PRESETS_CFG_PATH, exportPresets, {
    encoding: 'utf-8'
  });
  console.log(`Generating ${path.basename(VERSION_GD_PATH)}.`);
  fs.writeFileSync(VERSION_GD_PATH, [
    `# This file was auto-generated, do not edit it!`,
    `extends Node`,
    ``,
    `var VERSION = "${version}"`,
    ``
  ].join('\n'), {encoding: 'utf-8'});
}

if (!module.parent) {
  syncVersion();
}
