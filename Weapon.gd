extends Spatial

class_name Weapon

export var DAMAGE = 0
export var BASE_ANIM_NAME = ""

var IDLE_ANIM_NAME = ""
var FIRE_ANIM_NAME = ""
var EQUIP_ANIM_NAME = ""
var UNEQUIP_ANIM_NAME = ""

var is_weapon_enabled = false

var player_node = null


func _ready():
	IDLE_ANIM_NAME = BASE_ANIM_NAME + "_idle"
	FIRE_ANIM_NAME = BASE_ANIM_NAME + "_fire"
	EQUIP_ANIM_NAME = BASE_ANIM_NAME + "_equip"
	UNEQUIP_ANIM_NAME = BASE_ANIM_NAME + "_unequip"
	assert(BASE_ANIM_NAME != "", name + " should have BASE_ANIM_NAME set.")
	assert(DAMAGE > 0, name + " should have DAMAGE set.")


func equip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		is_weapon_enabled = true
		return true

	if player_node.animation_manager.current_state == "Idle_unarmed":
		player_node.animation_manager.set_animation(EQUIP_ANIM_NAME)

	return false


func unequip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		# Not sure why this next line exists, but it's in the tutorial code... Oh weird,
		# the tutorial code has an explanation for this, although I'm not sure I
		# believe it.
		if player_node.animation_manager.current_state != UNEQUIP_ANIM_NAME:
			player_node.animation_manager.set_animation(UNEQUIP_ANIM_NAME)
		else:
			print("Uh wow, the impossible happened?")

	if player_node.animation_manager.current_state == "Idle_unarmed":
		is_weapon_enabled = false
		return true

	return false


func fire_weapon():
	assert(false, name + " has not defined fire_weapon().")
