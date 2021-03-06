extends Spatial


onready var light: OmniLight = $OmniLight
onready var box: CSGBox = $CSGBox


func turn_on():
	light.visible = true
	box.material.emission_enabled = true


func turn_off():
	light.visible = false
	box.material.emission_enabled = false
