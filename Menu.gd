extends Control


var level = null
onready var objective_instructions = $Objective
onready var photo = $Objective/Photo
onready var start_button = $StartGameButton
onready var title = $Title
signal continue_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_StartGameButton_pressed():
	if level:
		emit_signal("continue_game")
	else:
		level = load("res://assets/Cooper_Hewitt/Cooper_Hewitt_Level.tscn").instance()
		var root = get_tree().root
		root.add_child(level)
		level.player.set_menu(self)
		start_button.text = "Continue game"
	self.visible = false


func _on_QuitGameButton_pressed():
	get_tree().quit()


func activate(photo_texture: ImageTexture):
	title.visible = false
	objective_instructions.visible = true
	photo.set_photo(photo_texture)
	self.visible = true


func _input(_event):
	if not self.visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if level:
			_on_StartGameButton_pressed()
