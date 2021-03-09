import * as fs from "fs";
import * as path from "path";
import * as child_process from "child_process";

// TODO: support publishing to itch via e.g.:
//   butler push dist toolness/cat-in-the-coop:html --userversion 0.0.1
//   butler push cat-in-the-coop-osx.zip toolness/cat-in-the-coop:osx-beta --userversion 0.0.1
//   butler push dist-windows toolness/cat-in-the-coop:windows-beta --userversion 0.0.1

const ROOT_DIR = path.normalize(path.join(__dirname, '..'));

const GODOT_PATH = "godot";

const BUTLER_PATH = "butler";

function runSync(path: string, args: string[]) {
  const result = child_process.spawnSync(
    path, args, {
      cwd: ROOT_DIR,
      stdio: 'inherit',
    }
  );
  if (result.status || result.status === null) {
    console.log("Subprocess failed, exiting.");
    process.exit(1);
  }
}

function ensureDirIsEmptySync(dirName: string) {
  if (!fs.existsSync(dirName)) {
    fs.mkdirSync(dirName);
  }
  
  for (let filename of fs.readdirSync(dirName)) {
    fs.unlinkSync(path.join(dirName, filename));
  }
}

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

if (!module.parent) {
  html5.exportSync();
}
