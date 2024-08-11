extends Node
class_name PauseLogic

@export var hud: Hud
@export var player: Player

func _process(delta):
	if not $LoopingMusic.playing:
		$LoopingMusic.play()
	
	if Input.is_action_just_pressed("map"):
		if not player.camera.switching_map_view:
			if player.camera.zoomed_out:
				player.camera.zoom_to_player()
				var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
				tween.tween_property(player.map_marker, "color:a", 0, 0.5)
				await tween.finished
				get_tree().paused = false
			else:
				player.camera.zoom_out_to_map()
				var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
				tween.tween_property(player.map_marker, "color:a", 1, 0.5)
				get_tree().paused = true
		
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			hud.hide_menu()
		else:
			hud.show_menu()
		get_tree().paused = not get_tree().paused
