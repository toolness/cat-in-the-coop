extends Spatial

class_name CatObjective

onready var collision_area: Area = $Collision_Area
onready var picture: Viewport = $Picture
onready var cat_spawn: Spatial = $Cat_Spawn
onready var camera: Camera = $Camera


func _ready():
    # During development, we have the camera as a direct descendant
    # of the objective so it moves with it, but at runtime we
    # re-parent it to the picture viewport so it actually renders
    # to it. (If we have it parented to the picture viewport during
    # development, Godot won't actually move the camera with the
    # rest of the objective, which is annoying.)
    var origin = camera.global_transform.origin
    var rot = camera.global_transform.basis
    self.remove_child(camera)
    picture.add_child(camera)
    camera.global_transform.origin = origin
    camera.global_transform.basis = rot
