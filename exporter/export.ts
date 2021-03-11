import * as path from "path";
import { syncVersion } from "./sync-version";
import { GODOT_PATH } from "./paths";
import { ensureDirIsEmptySync, runSync } from "./util";

// TODO: support publishing to itch via e.g.:
//   butler push dist toolness/cat-in-the-coop:html --userversion 0.0.1
//   butler push cat-in-the-coop-osx.zip toolness/cat-in-the-coop:osx-beta --userversion 0.0.1
//   butler push dist-windows toolness/cat-in-the-coop:windows-beta --userversion 0.0.1

interface Exporter {
  name: string;
  itchChannel: string;
  targetPath: string;

  exportSync(this: Exporter): void;
}

const html5: Exporter = {
  name: "html5",
  itchChannel: "html",
  targetPath: "dist",

  exportSync() {
    ensureDirIsEmptySync(this.targetPath);
    runSync(GODOT_PATH, ["--export", "HTML5", path.join(this.targetPath, 'index.html')]);
  }
};

const windows: Exporter = {
  name: "windows",
  itchChannel: "windows-beta",
  targetPath: "dist-windows",

  exportSync() {
    ensureDirIsEmptySync(this.targetPath);
    runSync(GODOT_PATH, ["--export", "Windows Desktop", path.join(this.targetPath, 'cat-in-the-coop.exe')]);
  }
};

const osx: Exporter = {
  name: "osx",
  itchChannel: "osx-beta",
  targetPath: path.join('dist-osx', 'cat-in-the-coop-osx.zip'),

  exportSync() {
    ensureDirIsEmptySync(path.dirname(this.targetPath));
    runSync(GODOT_PATH, ["--export", "Mac OSX", this.targetPath]);
  }
};

if (!module.parent) {
  syncVersion();
  osx.exportSync();
  windows.exportSync();
  html5.exportSync();
}
