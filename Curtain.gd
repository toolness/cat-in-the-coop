extends ColorRect


var label

const DELAY_BETWEEN_CHARS = 0.05
const END_OF_TEXT_WAIT = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	label = $Label


func show_text(text):
	self.visible = true
	label.text = text
	for i in range(len(text)):
		label.visible_characters = i
		yield(get_tree().create_timer(DELAY_BETWEEN_CHARS), "timeout")
	yield(get_tree().create_timer(END_OF_TEXT_WAIT), "timeout")


func hide():
	self.visible = false
