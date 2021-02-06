extends Node

class_name ObjectiveManager

const CATFOOD_DISTANCE_FROM_PLAYER = 10

var picture_texture
var objectives = []
var current_objective_idx = -1
var inside_objective: bool
var cat_scene = preload("res://Cat.tscn")
var catfood_scene = preload("res://Cat_Food.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is CatObjective:
			child.objective_manager = self
			objectives.append(child)
			child.visible = false
	# TODO: We should be picking a random objective to be our
	# current one, not using the first one we iterate over.
	set_current_objective(0)


func set_current_objective(i):
	if current_objective_idx != -1:
		objectives[current_objective_idx].visible = false
	current_objective_idx = i
	objectives[current_objective_idx].visible = true
	# TODO: This might be bad if the player is already in
	# the new objective's area.
	inside_objective = false

	yield(VisualServer, "frame_post_draw")
	picture_texture.texture = get_photo()


func set_inside_objective(inside: bool):
	inside_objective = inside


func put_down_food(player):
	var catfood = catfood_scene.instance()
	var in_front_of_player = player.global_transform.origin + (player.transform.basis.z.normalized() * CATFOOD_DISTANCE_FROM_PLAYER)
	# TODO: Ideally we should raycast or something to make sure the food doesn't
	# appear inside/beyonmd a wall, etc.
	catfood.global_transform.origin = in_front_of_player
	get_tree().root.add_child(catfood)

	if inside_objective:
		player.play_sound("jump")
		var pos = objectives[current_objective_idx].cat_spawn.global_transform.origin
		var cat = cat_scene.instance()
		cat.global_transform.origin = pos
		get_tree().root.add_child(cat)
		cat.set_food(catfood)
		set_current_objective((current_objective_idx + 1) % objectives.size())
	else:
		player.play_sound("zap")

func get_photo():
	# If we just return the texture from a Viewport's get_texture(), it will be
	# a dynamic texture that changes with the world. We'll "snapshot" the texture's
	# current data so it's a still image.
	var texture = ImageTexture.new()
	var image = objectives[current_objective_idx].picture.get_texture().get_data()
	texture.create_from_image(image)
	return texture
