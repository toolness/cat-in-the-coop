extends Spatial

class_name CatObjective

var collision_area
var picture
var cat_spawn
var objective_manager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_area = $Collision_Area
	cat_spawn = $Cat_Spawn
	collision_area.connect("body_entered", self, "area_entered")
	collision_area.connect("body_exited", self, "area_exited")


func area_entered(node: Node):
	if node.name == "Player":
		objective_manager.set_inside_objective(true)


func area_exited(node: Node):
	if node.name == "Player":
		objective_manager.set_inside_objective(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
