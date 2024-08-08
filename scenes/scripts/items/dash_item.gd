extends Item
class_name DashItem

@export var cooldown = 1
@export var duration = 0.3
@export var dash_speed = 400

var duration_timer: Timer
var cooldown_timer: Timer

func setup_duration():
	duration_timer = Timer.new()
	duration_timer.wait_time = duration
	duration_timer.one_shot = true
	duration_timer.autostart = false
	duration_timer.timeout.connect(_duration_timer_timeout)
	add_child(duration_timer)
	
func setup_cooldown():
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = false
	cooldown_timer.timeout.connect(_cooldown_timer_timeout)
	add_child(cooldown_timer)

func setup():
	setup_duration()
	setup_cooldown()

func _ready():
	setup()

var usable = true
	
func _physics_process(delta):
	if usable && Input.is_action_just_pressed("dash"):
		usable = false
		duration_timer.start()
		
		var dash_dir = -(int(player.animated_sprite_2d.flip_h) * 2 - 1) * player.gravity_dir.orthogonal()
		
		player.dash_velocity = dash_dir * dash_speed
		player.change_state(Player.state.DASH)
	
func _duration_timer_timeout():
	print("timeout")
	player.end_dash()
	cooldown_timer.start()

func _cooldown_timer_timeout():
	usable = true
