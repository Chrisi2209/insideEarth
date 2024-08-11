extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$HUD.start_menu()
	$Player.reset()
	$Player.camera.top_left_of_map = $TopLeft.global_position
	$Player.camera.bottom_right_of_map = $BottomRight.global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
				 


func _on_hud_start_game_pressed():
	pass
