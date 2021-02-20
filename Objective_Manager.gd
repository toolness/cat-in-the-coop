extends Node

class_name ObjectiveManager

const CATFOOD_DISTANCE_FROM_PLAYER = 10

var picture_texture
var player
var objectives = []
var current_objective_idx = -1
var inside_objective: bool
onready var curtain = $Curtain
var cat_scene = preload("res://Cat.tscn")
var catfood_scene = preload("res://Cat_Food.tscn")
var photo: ImageTexture


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


func initialize(new_player, new_picture_texture):
	player = new_player
	picture_texture = new_picture_texture


func set_current_objective(i):
	if current_objective_idx != -1:
		objectives[current_objective_idx].visible = false
	current_objective_idx = i
	objectives[current_objective_idx].visible = true
	# TODO: This might be bad if the player is already in
	# the new objective's area.
	inside_objective = false

	yield(set_picture_texture(), "completed")


func set_inside_objective(inside: bool):
	inside_objective = inside


func hide_and_remove(things):
	for thing in things:
		thing.visible = false
		thing.queue_free()


func put_down_food():
	var catfood = catfood_scene.instance()
	get_tree().root.add_child(catfood)

	var in_front_of_player = player.global_transform.origin + (player.transform.basis.z.normalized() * CATFOOD_DISTANCE_FROM_PLAYER)
	# TODO: Ideally we should raycast or something to make sure the food doesn't
	# appear inside/beyonmd a wall, etc.
	catfood.global_transform.origin = in_front_of_player

	player.pause()

	if inside_objective:
		player.play_sound("jump")
		var pos = objectives[current_objective_idx].cat_spawn.global_transform.origin
		var cat = cat_scene.instance()
		cat.transform.origin = pos
		get_tree().root.add_child(cat)
		cat.set_food(catfood)

		# TODO: We should really wait for a signal from the cat that indicates it has
		# started eating its food, since the cat could be very close to it or quite
		# far away.
		yield(curtain.wait(5.0), "completed")

		yield(curtain.show_text("You found your cat!"), "completed")
		yield(curtain.show_text("But a week later, you lose it again."), "completed")
		yield(
			set_current_objective((current_objective_idx + 1) % objectives.size()),
			"completed"
		)
		yield(curtain.show_text("Again, someone spots it on social media!"), "completed")
		curtain.set_photo(photo)
		yield(curtain.wait(3.0), "completed")
		hide_and_remove([catfood, cat])
		player.reset()
		curtain.hide()
	else:
		player.play_sound("zap")
		yield(curtain.wait(2.0), "completed")
		yield(curtain.show_text("Alas, it seems your cat is not nearby."), "completed")
		hide_and_remove([catfood])
		curtain.hide()

	player.unpause()


func suspend_giprobe():
	# It seems like if we want to disable a GIProbe, we have to actually
	# disable it--we can't just put it on a 3D render layer that a camera
	# culls out.
	var giprobe = get_tree().root.find_node("GIProbe", true, false)
	if giprobe:
		giprobe.visible = false

	yield()

	if giprobe:
		giprobe.visible = true


func place_cat_for_photo():
	var cat = cat_scene.instance()
	var collision_area = objectives[current_objective_idx].collision_area

	collision_area.add_child(cat)

	yield()

	collision_area.remove_child(cat)
	cat.queue_free()


func set_picture_texture():
	# Disabling the GIProbe while we take the photo will cause a momentary
	# flicker for the player, but we want the photo to have dramatically
	# different lighting than the player's world because it adds to the
	# challenge.
	var giprobe = suspend_giprobe()
	var cat = place_cat_for_photo()

	yield(VisualServer, "frame_post_draw")

	# If we just return the texture from a Viewport's get_texture(), it will be
	# a dynamic texture that changes with the world. We'll "snapshot" the texture's
	# current data so it's a still image.
	var texture = ImageTexture.new()
	var image = objectives[current_objective_idx].picture.get_texture().get_data()
	texture.create_from_image(image)

	photo = texture
	picture_texture.texture = texture

	cat.resume()
	giprobe.resume()
