const fs = require('fs');
const path = require('path');
const child_process = require('child_process');

// TODO: support publishing to itch via e.g.:
//   butler push dist toolness/cat-in-the-coop:html --userversion 0.0.1
//   butler push cat-in-the-coop-osx.zip toolness/cat-in-the-coop:osx-beta --userversion 0.0.1
//   butler push dist-windows toolness/cat-in-the-coop:windows-beta --userversion 0.0.1

const DIST_DIR = path.join(__dirname, 'dist');

if (!fs.existsSync(DIST_DIR)) {
  fs.mkdirSync(DIST_DIR);
}

for (let filename of fs.readdirSync(DIST_DIR)) {
  fs.unlinkSync(path.join(DIST_DIR, filename));
}

const result = child_process.spawnSync('godot', [
  '--export',
  'HTML5',
  path.join(DIST_DIR, 'index.html')
], {
  cwd: __dirname,
  stdio: 'inherit',
});

if (result.status || result.status === null) {
  process.exit(1);
}
