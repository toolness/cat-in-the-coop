extends Node


const WIN_MUSIC = preload("res://assets/joshua-mclean_50s-bit.ogg")

const START_LEVEL_MUSIC = preload("res://assets/toybox.ogg")


onready var music_player = AudioStreamPlayer.new()


func _ready():
	self.add_child(music_player)
	var result = PlayerConfig.connect("music_enabled_changed", self, "_on_music_enabled_changed")
	if result != OK:
		print("Failed to connect 'music_enabled_changed' signal.")


func play(music: AudioStreamOGGVorbis):
	if PlayerConfig.music_enabled:
		music_player.stream = music
		music_player.play()


func stop():
	music_player.stop()


func _on_music_enabled_changed(value: bool):
	if not value:
		music_player.stop()
