extends Node

class_name ObjectiveManager

var current_objective
var inside_objective
var cat_scene = preload("res://Cat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CatObjective:
			child.objective_manager = self
		# TODO: We should be picking a random objective to be our
		# current one, not using the last one we iterate over.
		# TODO: Also, we want to disable the objectives that aren't
		# the current ones!
		current_objective = child

func set_inside_objective(inside: bool):
	inside_objective = inside


func put_down_food(player):
	if inside_objective:
		player.play_sound("jump")
		var pos = current_objective.cat_spawn.global_transform.origin
		var cat = cat_scene.instance()
		cat.global_transform.origin = pos
		get_tree().root.add_child(cat)
	else:
		player.play_sound("zap")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
