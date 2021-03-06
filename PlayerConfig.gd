extends Node


onready var _config = ConfigFile.new()

const DEFAULT_MOUSE_SENSITIVITY = 50
const CONFIG_FILENAME = "user://player_config.cfg"

var mouse_sensitivity: int setget set_mouse_sensitivity


func _get_int_value(section: String, key: String, default_value: int) -> int:
    var value = _config.get_value(section, key, default_value)
    if value is int:
        return value
    return default_value


func _set_int_value(section: String, key: String, value: int):
    _config.set_value(section, key, value)
    _config.save(CONFIG_FILENAME)


func _ready():
    _config.load(CONFIG_FILENAME)
    mouse_sensitivity = _get_int_value("input", "mouse_sensitivity", DEFAULT_MOUSE_SENSITIVITY)


func set_mouse_sensitivity(value: int):
    mouse_sensitivity = value
    _set_int_value("input", "mouse_sensitivity", value)
