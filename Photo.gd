extends ColorRect


onready var image = $Image


func set_photo(texture):
	image.texture = texture
