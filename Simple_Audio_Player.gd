extends Spatial


var stream_player

var sounds = {
	"jump": preload("res://assets/jump.wav"),
	"quicksound": preload("res://assets/quicksound.wav"),
	"zap": preload("res://assets/zap.wav"),
	"song": preload("res://assets/song.wav")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	stream_player = $Audio_Stream_Player
	stream_player.connect("finished", self, "handle_finished")


func play_sound(name, position = null):
	stream_player.stream = sounds[name]
	if position != null:
		global_transform = position
	stream_player.play()

func stop_sound():
	stream_player.stop()
	
func handle_finished():
	queue_free()
