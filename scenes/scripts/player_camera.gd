extends Camera2D
class_name PlayerCamera

var need_turn_on_position_smoothing_in_frames = -1

func turn_off_position_smoothing_for_frames(frames: int):
	position_smoothing_enabled = false
	need_turn_on_position_smoothing_in_frames = frames

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if need_turn_on_position_smoothing_in_frames > 0:
		need_turn_on_position_smoothing_in_frames -= 1
	elif need_turn_on_position_smoothing_in_frames == 0:
		need_turn_on_position_smoothing_in_frames = -1
		position_smoothing_enabled = true
