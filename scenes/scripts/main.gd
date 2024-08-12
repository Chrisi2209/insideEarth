extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$Player.camera.top_left_of_map = $TopLeft.global_position
	$Player.camera.bottom_right_of_map = $BottomRight.global_position
	
	$HUD.start_menu()
	
	
	for child in get_children():
		if child is Room:
			child.visible = false
	
func reset_player():
	$Player.reset()
	$Player.room = $StartRoom
	$Player.global_position = $StartLocation.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BossRoom.visible = true
	$HUD.update_items($Player/DoublejumpItem != null,
		$Player/DashItem != null,
		$Player/Pickaxe != null,
		$Player/Key != null)
	

func _on_hud_start_game_pressed():
	pass

func _on_hud_respawn():
	reset_player()
