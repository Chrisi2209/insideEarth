extends Node
class_name PauseLogic

@export var hud: Hud
@export var player: Player

func _process(delta):
	if Input.is_action_just_pressed("map"):
		if player.camera.zoomed_out:
			player.camera.zoom_to_player()
			get_tree().paused = false
		else:
			player.camera.zoom_out_to_map()
			get_tree().paused = true
		
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			hud.hide_menu()
		else:
			hud.show_menu()
		get_tree().paused = not get_tree().paused
