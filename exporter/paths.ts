import * as path from "path";

export const ROOT_DIR = path.normalize(path.join(__dirname, '..'));

export const VERSION_TXT_PATH = path.join(ROOT_DIR, 'version.txt');

export const VERSION_GD_PATH = path.join(ROOT_DIR, 'version.gd');

export const EXPORT_PRESETS_CFG_PATH = path.join(ROOT_DIR, 'export_presets.cfg');

export const GODOT_PATH = "godot";

export const BUTLER_PATH = "butler";
