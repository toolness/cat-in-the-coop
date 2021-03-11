import * as fs from "fs";
import * as path from "path";
import * as child_process from "child_process";
import { ROOT_DIR } from "./paths";

export function runSync(path: string, args: string[]) {
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

export function ensureDirIsEmptySync(dirName: string) {
  if (!fs.existsSync(dirName)) {
    fs.mkdirSync(dirName);
  }
    
  for (let filename of fs.readdirSync(dirName)) {
    fs.unlinkSync(path.join(dirName, filename));
  }
}
