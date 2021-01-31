extends Node

class_name ObjectiveManager

var inside_objective

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child:
			child.objective_manager = self

func set_inside_objective(inside: bool):
	inside_objective = inside


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
