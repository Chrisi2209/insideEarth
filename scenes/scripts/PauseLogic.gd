extends Node
class_name PauseLogic
@export var hud: Hud
@export var player: Player
const DOOR_LINE_CONNECTOR = preload("res://scenes/door_line_connector.tscn")
var showing_lines = false
var DoorLineContainer
var stop_music = false

func _process(delta):
	if not $LoopingMusic.playing && not stop_music:
		$LoopingMusic.play()
	elif stop_music:
		$LoopingMusic.stop()
	

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
	if player.camera.zoomed_out:
		hud.change_interaction_label("F to show door connections")
		if Input.is_action_just_pressed("interact"):
			if showing_lines == false:
				DoorLineContainer = Node.new()
				add_child(DoorLineContainer)
				for door_pair in Global.door_pairs:
					var DoorLineConnector = DOOR_LINE_CONNECTOR.instantiate()
					DoorLineConnector.add_point(door_pair[0].global_position)
					DoorLineConnector.add_point(door_pair[1].global_position)
					DoorLineContainer.add_child(DoorLineConnector)
					showing_lines = true
			elif DoorLineContainer != null:
				DoorLineContainer.queue_free()
				showing_lines = false
	if not player.camera.zoomed_out:
		hud.change_interaction_label("Interact - F") 
		if DoorLineContainer != null:
			DoorLineContainer.queue_free()
			showing_lines = false
