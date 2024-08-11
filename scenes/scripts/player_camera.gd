extends Camera2D
class_name PlayerCamera

var need_turn_on_position_smoothing_in_frames = -1
@export var top_left_of_map: Vector2
@export var bottom_right_of_map: Vector2
var switching_map_view = false

func turn_off_position_smoothing_for_frames(frames: int):
	position_smoothing_enabled = false
	need_turn_on_position_smoothing_in_frames = frames

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var zoomed_out = false

func zoom_out_to_map():
	switching_map_view = true
	var diagonal = top_left_of_map - bottom_right_of_map
	var middle_point = diagonal / 2 + bottom_right_of_map
	var length = diagonal.length()
	var screen_size = get_viewport_rect().size
	
	var scale_x = abs(diagonal.x) / screen_size.x
	var scale_y = abs(diagonal.y) / screen_size.y
	
	var scale = max(1 / scale_x, 1 / scale_y)
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "zoom", Vector2(scale, scale), 0.5)
	tween.tween_property(self, "global_position", middle_point, 0.5)
	tween.tween_property(self, "global_rotation", 0, 0.5)
	zoomed_out = true
	position_smoothing_enabled = false
	
	await tween.finished
	switching_map_view = false

func zoom_to_player():
	switching_map_view = true
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "zoom", Vector2.ONE, 0.5)
	tween.tween_property(self, "position", Vector2.ZERO, 0.5)
	tween.tween_property(self, "rotation", 0, 0.5)
	await tween.finished
	switching_map_view = false
	position_smoothing_enabled = true
	zoomed_out = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if need_turn_on_position_smoothing_in_frames > 0:
		need_turn_on_position_smoothing_in_frames -= 1
	elif need_turn_on_position_smoothing_in_frames == 0:
		need_turn_on_position_smoothing_in_frames = -1
		position_smoothing_enabled = true
