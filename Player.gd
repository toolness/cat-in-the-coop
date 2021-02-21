extends KinematicBody

class_name Player

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 20
const MAX_SPRINT_SPEED = 30
const JUMP_SPEED = 18
const ACCEL = 4.5
const SPRINT_ACCEL = 18
var is_sprinting = false

var dir = Vector3()

const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var flashlight
var starting_position
var starting_rotation

var MOUSE_SENSITIVITY = 0.05

var JOYPAD_SENSITIVITY = 2
var joypad

var menu = null

var picture_texture

var objective_manager: ObjectiveManager

var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = global_transform.origin
	starting_rotation = rotation
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	flashlight = $Rotation_Helper/Flashlight

	camera.make_current()

	if OS.get_name() == "Windows":
		joypad = WindowsJoypad.new()
	else:
		joypad = Joypad.new()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	picture_texture = $HUD/Panel/TextureRect


func set_menu(new_menu):
	menu = new_menu
	menu.connect("continue_game", self, "_on_continue_game")


func _on_continue_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unpause()


func reset():
	global_transform.origin = starting_position
	rotation = starting_rotation


func set_objective_manager(new_objective_manager):
	objective_manager = new_objective_manager
	objective_manager.initialize(self, picture_texture)


func pause():
	is_paused = true

func unpause():
	# If we unpause instantly, the our input handler
	# might process whatever the player may have just pressed to unpause,
	# which we don't want. So we'll wait a bit before unpausing. (Note
	# that I tried waiting for "idle_frame" and "physics_frame" instead
	# of this hard-coded timeout, but both happened too quickly to prevent
	# the double-processing of input.)
	yield(get_tree().create_timer(0.05), "timeout")

	is_paused = false


func _physics_process(delta):
	if is_paused:
		return

	process_input(delta)
	process_movement(delta)
	process_view_input(delta)


func process_input(_delta):
	# ----------------------------
	# Walking
	# ----------------------------

	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1

	input_movement_vector += joypad.get_axis(joypad.MOVEMENT_AXIS)

	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# ----------------------------
	# Sprinting
	# ----------------------------

	is_sprinting = Input.is_action_pressed("movement_sprint")

	# ----------------------------
	# Flashlight
	# ----------------------------

	if Input.is_action_just_pressed("flashlight"):
		if flashlight.is_visible_in_tree():
			flashlight.hide()
		else:
			flashlight.show()

	# ----------------------------
	# Jumping
	# ----------------------------

	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			play_sound("jump", global_transform)
			vel.y = JUMP_SPEED

	# ----------------------------
	# Capturing/freeing the cursor
	# ----------------------------

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if menu:
				pause()
				menu.activate(objective_manager.photo)


	if Input.is_action_just_pressed("fire"):
		objective_manager.put_down_food()

	if Input.is_action_just_pressed("reload"):
		var visibility = !$HUD.visible
		$HUD.visible = visibility


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	if is_sprinting:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		if is_sprinting:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


class Joypad:
	const MOVEMENT_AXIS = 0
	const ROTATION_AXIS = 1
	const DEADZONE = 0.15

	func _get_axis(_axis: int) -> Vector2:
		return Vector2()

	func get_axis(axis: int) -> Vector2:
		var vec = Vector2()

		if Input.get_connected_joypads().size() > 0:
			vec = _get_axis(axis)

			if vec.length() < DEADZONE:
				vec = Vector2(0, 0)
			else:
				vec = vec.normalized() * ((vec.length() - DEADZONE) / (1 - DEADZONE))

		return vec


class WindowsJoypad:
	extends Joypad

	func _get_axis(axis: int) -> Vector2:
		if axis == MOVEMENT_AXIS:
			return Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0, 1))
		assert(axis == ROTATION_AXIS)
		return Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))


func process_view_input(_delta):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	# NOTE: The original tutorial said something about not being able to
	# do mouse stuff here until some bugs are fixed, which I guess is why
	# we process mouselook logic elsewhere.

	var joypad_vec = joypad.get_axis(joypad.ROTATION_AXIS)

	rotate_camera(
		joypad_vec.y * JOYPAD_SENSITIVITY,
		joypad_vec.x * JOYPAD_SENSITIVITY * -1
	)


func rotate_camera(x_axis_degrees, y_axis_degrees):
	rotation_helper.rotate_x(deg2rad(x_axis_degrees))
	self.rotate_y(deg2rad(y_axis_degrees))

	var camera_rot = rotation_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, -70, 70)
	rotation_helper.rotation_degrees = camera_rot


func _input(event):
	if is_paused:
		return

	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		rotate_camera(
			event.relative.y * MOUSE_SENSITIVITY,
			event.relative.x * MOUSE_SENSITIVITY * -1
		)

var simple_audio_player = preload("res://Simple_Audio_Player.tscn")


func play_sound(name, position = null):
	var player = simple_audio_player.instance()
	get_tree().root.add_child(player)
	player.play_sound(name, position)

	return player
