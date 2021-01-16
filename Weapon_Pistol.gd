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
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		is_weapon_enabled = true
		return true
	
	if player_node.animation_manager.current_state == "Idle_unarmed":
		player_node.animation_manager.set_animation("Pistol_equip")

	return false


func unequip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		# Not sure why this next line exists, but it's in the tutorial code... Oh weird,
		# the tutorial code has an explanation for this, although I'm not sure I
		# believe it.
		if player_node.animation_manager.current_state != "Pistol_unequip":
			player_node.animation_manager.set_animation("Pistol_unequip")

	if player_node.animation_manager.current_state == "Idle_unarmed":
		is_weapon_enabled = false
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
