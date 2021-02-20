extends ColorRect


var label
var photo
var photo_image
var is_waiting: bool = false
var latest_timer_id: int = 0

const DELAY_BETWEEN_CHARS = 0.05
const END_OF_TEXT_WAIT = 2.0

signal wait_finished(was_cancelled)

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label
	photo = $Photo
	photo_image = $Photo/Image


func show_text(text):
	self.visible = true
	label.visible = true
	photo.visible = false
	label.text = text
	for i in range(len(text)):
		label.visible_characters = i
		var was_cancelled = yield(wait(DELAY_BETWEEN_CHARS), "completed")
		if was_cancelled:
			label.visible_characters = len(text) - 1
			break
	yield(wait(END_OF_TEXT_WAIT), "completed")


func set_photo(texture):
	self.visible = true
	label.visible = false
	photo.visible = true
	photo_image.texture = texture


func hide():
	self.visible = false


func wait(seconds: float):
	# Er, there doesn't seem to be a way to cancel the timer, so
	# we'll keep track of the latest timer ID and use that to ensure
	# that stale timers don't trigger the current one...
	var current_timer_id = latest_timer_id
	var timer = get_tree().create_timer(seconds)
	timer.connect("timeout", self, "_on_timer_timeout", [current_timer_id])

	is_waiting = true
	var was_cancelled = yield(self, "wait_finished")
	latest_timer_id += 1
	is_waiting = false

	if was_cancelled:
		# Ack, if we return instantly, the player input handler
		# will process whatever the player just pressed to cancel the timer,
		# which we don't want. So we'll wait a bit before returning. (Note
		# that I tried waiting for "idle_frame" and "physics_frame" instead
		# of this hard-coded timeout, but both happened too quickly to prevent
		# the double-processing of input.)
		yield(get_tree().create_timer(0.05), "timeout")

	return was_cancelled


func _on_timer_timeout(timer_id):
	if timer_id == latest_timer_id:
		emit_signal("wait_finished", false)


func _input(_event):
	if is_waiting:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("fire"):
			emit_signal("wait_finished", true)
