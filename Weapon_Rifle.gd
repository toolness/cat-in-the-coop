extends Spatial

const DAMAGE = 4

const IDLE_ANIM_NAME = "Rifle_idle"
const FIRE_ANIM_NAME = "Rifle_fire"

var is_weapon_enabled = false

var player_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fire_weapon():
	var ray = $Ray_Cast
	ray.force_raycast_update()

	if ray.is_colliding():
		var body = ray.get_collider()
		if body == player_node:
			pass
		elif body.has_method("bullet_hit"):
			body.bullet_hit(DAMAGE, ray.global_transform)


func equip_weapon():
	return player_node.equip_weapon(self, "Rifle_equip")


func unequip_weapon():
	return player_node.unequip_weapon(self, "Rifle_unequip")
