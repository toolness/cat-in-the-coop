const fs = require('fs');
const path = require('path');
const child_process = require('child_process');

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
