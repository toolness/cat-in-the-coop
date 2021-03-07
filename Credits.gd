extends Spatial


onready var curtain = $Curtain
var ui_cancel_pressed = false

signal finished

var LINES = [
	"T-Sub Squiggle is\n\nErik Christensen (T-Sub)\nAtul Varma (Squiggle)",
	"Programming\n\nT-Sub Squiggle",
	"Design\n\nT-Sub Squiggle",
	"Music\n\nJoshua McLean\nCC-BY-4.0",
	"Cat\n\nVr-cvantorium on Sketchfab\nCC-BY-4.0",
	"Carnegie Mansion\n\nSmithsonian 3D Digitization\nCC-0",
	"Titillium Font\n\nAccademia di Belle Arti di Urbino\nSIL Open Font License v1.10",
	"Clumsy Blender Tomfoolery\n\nSquiggle",
	"Additional code provided by\nthe Godot community",
]


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.play(MusicPlayer.WIN_MUSIC)
	for line in LINES:
		yield(curtain.show_text(line), "completed")
		if ui_cancel_pressed: break
		yield(curtain.wait(2.0), "completed")
		if ui_cancel_pressed: break
	MusicPlayer.stop()
	emit_signal("finished")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		ui_cancel_pressed = true
