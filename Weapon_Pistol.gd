extends Spatial


const DAMAGE = 15

const IDLE_ANIM_NAME = "Pistol_idle"
const FIRE_ANIM_NAME = "Pistol_fire"

var is_weapon_enabled = false

var bullet_scene = preload("Bullet_Scene.tscn")

var player_node = null


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


func equip_weapon():
	return player_node.equip_weapon(self, "Pistol_equip")


func unequip_weapon():
	return player_node.unequip_weapon(self, "Pistol_unequip")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
