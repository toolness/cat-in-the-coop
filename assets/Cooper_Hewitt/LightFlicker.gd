extends OmniLight

const MIN_TIME_TO_UNFLICKER = 0.1
const MAX_TIME_TO_UNFLICKER = 3

const MIN_TIME_BETWEEN_FLICKER = 0.25
const MAX_TIME_BETWEEN_FLICKER = 30

var time_until_flicker_change = 0
var time_since_last_flicker = MIN_TIME_BETWEEN_FLICKER

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_flicker += delta
	if visible:
		if time_since_last_flicker >= time_until_flicker_change:
			visible = false
			time_until_flicker_change = rand_range(MIN_TIME_TO_UNFLICKER, MAX_TIME_TO_UNFLICKER)
			time_since_last_flicker = 0
	else:
		if time_since_last_flicker >= time_until_flicker_change:
			visible = true
			time_until_flicker_change = rand_range(MIN_TIME_BETWEEN_FLICKER, MAX_TIME_BETWEEN_FLICKER)
