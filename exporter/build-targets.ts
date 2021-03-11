import * as path from "path";
import { GODOT_PATH } from "./paths";
import { ensureDirIsEmptySync, runSync } from "./util";

export interface BuildTarget {
  itchChannel: string;
  targetPath: string;

  buildSync(this: BuildTarget): void;
}

const html5: BuildTarget = {
  itchChannel: "html",
  targetPath: "dist",

  buildSync() {
    ensureDirIsEmptySync(this.targetPath);
    runSync(GODOT_PATH, ["--export", "HTML5", path.join(this.targetPath, 'index.html')]);
  }
};

const windows: BuildTarget = {
  itchChannel: "windows-beta",
  targetPath: "dist-windows",

  buildSync() {
    ensureDirIsEmptySync(this.targetPath);
    runSync(GODOT_PATH, ["--export", "Windows Desktop", path.join(this.targetPath, 'cat-in-the-coop.exe')]);
  }
};

const osx: BuildTarget = {
  itchChannel: "osx-beta",
  targetPath: path.join('dist-osx', 'cat-in-the-coop-osx.zip'),

  buildSync() {
    ensureDirIsEmptySync(path.dirname(this.targetPath));
    runSync(GODOT_PATH, ["--export", "Mac OSX", this.targetPath]);
  }
};

export const BUILD_TARGETS = new Map<string, BuildTarget>([
  ["osx", osx],
  ["windows", windows],
  ["html5", html5],
]);

export const BUILD_TARGET_NAMES = Array.from(BUILD_TARGETS.keys());
