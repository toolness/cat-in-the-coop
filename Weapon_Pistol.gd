extends Weapon


var bullet_scene = preload("Bullet_Scene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fire_weapon():
	var clone = bullet_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)

	clone.global_transform = self.global_transform
	clone.scale = Vector3(4, 4, 4)
	clone.BULLET_DAMAGE = DAMAGE

	ammo_in_weapon -= 1
