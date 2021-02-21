extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Player
onready var objective_manager = $Objective_Manager


# Called when the node enters the scene tree for the first time.
func _ready():
	player.set_objective_manager(objective_manager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
