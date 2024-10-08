extends Item
class_name DashItem

@export var cooldown = 1.2
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
var touched_ground = false
var cooldown_timeout = false
	
func _physics_process(delta):
	if usable && Input.is_action_just_pressed("dash"):
		usable = false
		touched_ground = false
		cooldown_timeout = false
		duration_timer.start()
		$DashSound.play()
		
		var dash_dir = -(int(player.animated_sprite_2d.flip_h) * 2 - 1) * player.gravity_dir.orthogonal()
		
		player.dash_velocity = dash_dir * dash_speed
		player.change_state(Player.state.DASH)

func _process(delta):
	if player.is_on_floor():
		touched_ground = true
	
	if touched_ground && cooldown_timeout:
		usable = true
	
func _duration_timer_timeout():
	player.end_dash()
	cooldown_timer.start()

func _cooldown_timer_timeout():
	cooldown_timeout = true
