extends Spatial


const DAMAGE = 40

const IDLE_ANIM_NAME = "Knife_idle"
const FIRE_ANIM_NAME = "Knife_fire"

var is_weapon_enabled = false

var player_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fire_weapon():
	var area = $Area
	var bodies = area.get_overlapping_bodies()

	for body in bodies:
		if body == player_node:
			continue

		if body.has_method("bullet_hit"):
			body.bullet_hit(DAMAGE, area.global_transform)


func equip_weapon():
	return player_node.equip_weapon(self, "Knife_equip")


func unequip_weapon():
	return player_node.unequip_weapon(self, "Knife_unequip")
