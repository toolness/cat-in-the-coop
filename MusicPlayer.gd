extends Node


const WIN_MUSIC = preload("res://assets/joshua-mclean_50s-bit.ogg")

const START_LEVEL_MUSIC = preload("res://assets/toybox.ogg")


onready var music_player = AudioStreamPlayer.new()


func _ready():
	self.add_child(music_player)


func play(music: AudioStreamOGGVorbis):
	music_player.stream = music
	music_player.play()


func stop():
	music_player.stop()
