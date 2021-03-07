extends AudioStreamPlayer


const WIN_MUSIC = preload("res://assets/joshua-mclean_50s-bit.ogg")

const START_LEVEL_MUSIC = preload("res://assets/toybox.ogg")


func play_music(music: AudioStreamOGGVorbis):
	stream = music
	play()
