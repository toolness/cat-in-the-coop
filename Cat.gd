extends Spatial

export(NodePath) var spawn_points
export(float) var time_between_teleports
var anim_player

var time_elapsed = 0
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player = $AnimationPlayer
	loop_animation("ArmatureAction")
	anim_player.connect("animation_finished", self, "loop_animation")
	time_elapsed = 0
	rng = RandomNumberGenerator.new()


func loop_animation(anim_name):
	anim_player.play(anim_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	if spawn_points and time_elapsed >= time_between_teleports:
		time_elapsed = 0
		var spawn_points_node = get_node(spawn_points)
		var num_children = spawn_points_node.get_child_count()
		var random_child = rng.randi_range(0, num_children - 1)
		var child = spawn_points_node.get_child(random_child)
		global_transform.origin = child.global_transform.origin
		print("Teleported!")
