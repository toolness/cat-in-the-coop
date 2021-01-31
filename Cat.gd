extends Spatial

export(NodePath) var spawn_points
export(float) var time_between_teleports
var MOVE_SPEED = 0.1
var AT_FOOD_DISTANCE = 3
var AT_FOOD_DISTANCE_SQUARED = AT_FOOD_DISTANCE * AT_FOOD_DISTANCE
var anim_player
var food

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


func set_food(new_food):
	food = new_food
	look_at(food.global_transform.origin, transform.basis.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	if food:
		var cat_pos = global_transform.origin
		var food_pos = food.global_transform.origin
		var distance_to_food = (cat_pos - food_pos).length_squared()
		if distance_to_food > AT_FOOD_DISTANCE_SQUARED:
			global_transform.origin = cat_pos.move_toward(food_pos, MOVE_SPEED)
