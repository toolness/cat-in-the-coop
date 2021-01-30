extends CSGSphere


var TIME_BETWEEN_TELEPORTS = 1
var time_elapsed = 0
var rng

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	time_elapsed = 0
	rng = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	if time_elapsed >= TIME_BETWEEN_TELEPORTS:
		time_elapsed = 0
		#var root = get_tree().root
		var spawn_points = get_node(@"../Cat_Spawn_Points")
		var num_children = spawn_points.get_child_count()
		var random_child = rng.randi_range(0, num_children - 1)
		var child = spawn_points.get_child(random_child)
		global_transform.origin = child.global_transform.origin
		print("Teleported!")
