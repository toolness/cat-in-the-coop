extends Control


var level = null
onready var objective_instructions = $Objective
onready var photo = $Objective/Photo
onready var start_button = $StartGameButton
onready var title = $Title
onready var quit_button = $QuitGameButton
onready var mouse_slider = $MouseSlider
var activate_start_time = 0
signal continue_game

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_slider.value = PlayerConfig.mouse_sensitivity
	if OS.get_name() == "HTML5":
		quit_button.visible = false


func _on_StartGameButton_pressed():
	if level:
		emit_signal("continue_game")
	else:
		level = load("res://assets/Cooper_Hewitt/Cooper_Hewitt_Level.tscn").instance()
		var root = get_tree().root
		root.add_child(level)
		level.player.set_menu(self)
		level.objective_manager.play_intro()
		start_button.text = "Continue game"
	self.visible = false


func _on_QuitGameButton_pressed():
	get_tree().quit()


func _on_CreditsButton_pressed():
	var _result = OS.shell_open("https://github.com/toolness/cat-in-the-coop#credits")


func activate(photo_texture: ImageTexture):
	title.visible = false
	objective_instructions.visible = true
	photo.set_photo(photo_texture)
	self.visible = true
	activate_start_time = OS.get_ticks_msec()


func _input(event):
	# If we process input instantly after being activated, our input handler
	# might process whatever the player may have just pressed to pause,
	# which we don't want. So we'll wait a bit before processing input to
	# potentially unpause the game.
	var did_time_pass = OS.get_ticks_msec() - activate_start_time > 250

	if not (self.visible and did_time_pass):
		return
	if event.is_action_pressed("ui_cancel"):
		if level:
			_on_StartGameButton_pressed()


func _on_FullscreenCheckbox_toggled(is_toggled):
	OS.window_fullscreen = is_toggled


func _on_MouseSlider_value_changed(value: float):
	PlayerConfig.mouse_sensitivity = int(value)
