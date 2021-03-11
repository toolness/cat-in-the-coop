import { docopt } from "docopt";
import { BuildTarget, BUILD_TARGETS, BUILD_TARGET_NAMES } from "./build-targets";
import { BUTLER_PATH, VERSION_TXT_PATH } from "./paths";
import { syncVersion } from "./sync-version";
import { runSync } from "./util";

const DOCS = `
Usage:
  export build <target>...
  export publish <target>...
  export syncversion
  export -h | --help

Notes:
  <target> is one of ${BUILD_TARGET_NAMES.join(', ')}, or all (for all targets).

  The "build" command will export the game using Godot. It requires the "godot"
  executable to be on your PATH.

  The "publish" command will publish the built game to itch.io. It requires
  the "butler" executable to be on your PATH.

  The "syncversion" command will update all metadata in the game to use
  the version specified in version.txt.
`.trim();

type Options = {
  '--help': boolean,
  '-h': boolean,
  '<target>': string[],
  build: boolean,
  publish: boolean,
  syncversion: boolean,
};

const ITCH_PROJECT = "toolness/cat-in-the-coop";

function publishSync(target: BuildTarget) {
  runSync(BUTLER_PATH, [
    'push',
    target.targetPath,
    `${ITCH_PROJECT}:${target.itchChannel}`,
    '--userversion-file',
    VERSION_TXT_PATH
  ]);
}

export function main() {
  const opts: Options = docopt(DOCS, {});
  if (opts["<target>"].length === 1 && opts["<target>"][0] === "all") {
    opts["<target>"] = BUILD_TARGET_NAMES;
  }
  const targets: [string, BuildTarget][] = [];

  opts["<target>"].forEach(name => {
    const result = BUILD_TARGETS.get(name);
    if (!result) {
      console.log(`Unknown target: ${name}`);
      console.log(`Please choose from ${BUILD_TARGET_NAMES.join(', ')}, or all.`);
      process.exit(1);
    }
    targets.push([name, result]);
  });

  if (opts.syncversion) {
    syncVersion();
  } else if (opts.build) {
    for (let [name, target] of targets) {
      console.log(`Building ${name}.`);
      target.buildSync();
    }
    console.log(`Finished building ${targets.length} target(s).`);
  } else if (opts.publish) {
    for (let [name, target] of targets) {
      console.log(`Publishing ${name}.`);
      publishSync(target);
    }
    console.log(`Finished publishing ${targets.length} target(s).`);
  }
}
