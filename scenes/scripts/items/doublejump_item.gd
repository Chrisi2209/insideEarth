extends Item
class_name DoublejumpItem

@export var cooldown = 1.5
var timer: Timer

func setup_timer():
	timer = Timer.new()
	timer.wait_time = cooldown
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)

var usable = true: set = set_usable

func set_usable(value: bool):
	usable = value
	if usable == false:
		timer.start()

func _ready():
	setup_timer()
	
func triggered_jump():
	was_on_floor = false
	usable = false

var last_player_state: Player.state
var was_on_floor: bool = false

func _physics_process(delta):
	if usable:
		if last_player_state == Player.state.JUMP && Input.is_action_just_pressed("jump"):
			player.jump(self, 1)
	else:
		if player.is_on_floor():
			was_on_floor = true
		if timer.is_stopped() && was_on_floor:
			usable = true
	
	last_player_state = player.current_state
