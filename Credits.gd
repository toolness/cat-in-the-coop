extends Spatial


onready var curtain = $Curtain
var ui_cancel_pressed = false

signal finished

var LINES = [
	"T-Sub Squiggle is\n\nErik Christensen (T-Sub)\nAtul Varma (Squiggle)",
	"Programming\n\nT-Sub Squiggle",
	"Music\n\nJoshua McLean"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for line in LINES:
		yield(curtain.show_text(line), "completed")
		yield(curtain.wait(3.0), "completed")
		if ui_cancel_pressed:
			break
	emit_signal("finished")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ui_cancel_pressed = true
