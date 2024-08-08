extends Item
class_name DoublejumpItem

var usable = true
	
func triggered_jump():
	usable = false

var last_player_state: Player.state

func _physics_process(delta):
	if usable:
		if last_player_state == Player.state.JUMP && Input.is_action_just_pressed("jump"):
			player.jump(self, 1)
	elif player.is_on_floor():
		usable = true
	
	last_player_state = player.current_state
