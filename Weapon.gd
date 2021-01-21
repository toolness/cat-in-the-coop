extends Spatial

class_name Weapon

export var DAMAGE = 0
export var BASE_ANIM_NAME = ""
export var AMMO_IN_MAG = 1
export var CAN_RELOAD = false
export var CAN_REFILL = false

var IDLE_ANIM_NAME = ""
var FIRE_ANIM_NAME = ""
var EQUIP_ANIM_NAME = ""
var UNEQUIP_ANIM_NAME = ""
var RELOADING_ANIM_NAME = ""

var is_weapon_enabled = false

var player_node = null

var ammo_in_weapon = 1
var spare_ammo = 1

func _ready():
	IDLE_ANIM_NAME = BASE_ANIM_NAME + "_idle"
	FIRE_ANIM_NAME = BASE_ANIM_NAME + "_fire"
	EQUIP_ANIM_NAME = BASE_ANIM_NAME + "_equip"
	UNEQUIP_ANIM_NAME = BASE_ANIM_NAME + "_unequip"
	RELOADING_ANIM_NAME = BASE_ANIM_NAME + "_reload"
	assert(BASE_ANIM_NAME != "", name + " should have BASE_ANIM_NAME set.")
	assert(DAMAGE > 0, name + " should have DAMAGE set.")
	ammo_in_weapon = AMMO_IN_MAG
	spare_ammo = ammo_in_weapon * 2


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


func reload_weapon():
	# I'm adding this conditional myself, it's not in the original tutorial.
	# Easier than overriding this method for weapons that can't reload, though.
	if not CAN_RELOAD:
		return false
	
	var can_reload = false

	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		can_reload = true
	
	if spare_ammo <= 0 or ammo_in_weapon == AMMO_IN_MAG:
		can_reload = false
	
	if can_reload == true:
		var ammo_needed = AMMO_IN_MAG - ammo_in_weapon

		if spare_ammo >= ammo_needed:
			spare_ammo -= ammo_needed
			ammo_in_weapon = AMMO_IN_MAG
		else:
			ammo_in_weapon += spare_ammo
			spare_ammo = 0

		player_node.animation_manager.set_animation(RELOADING_ANIM_NAME)

		return true

	return false
