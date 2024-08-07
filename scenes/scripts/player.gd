extends CharacterBody2D

class_name Player

# physics
@export var SPEED = 400.0
@export var JUMP_VELOCITY = 400.0

var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_dir = Vector2(0, 1)
var down_force: float
var side_force: float
@export var gravity_center: Vector2

# nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

# double jump orb
var inside_doublejump_orb_list: Array = []

# health
signal health_changed
const max_health: int = 3
var health: int: set = set_health

func set_health(value: int):
	if value <= 0:
		health = 0
		change_state(state.DEAD)
	else:
		health = value
		change_state(state.INVULNERABLE)
		
	health_changed.emit(health)

# states
enum state {IDLE, WALK, JUMP, DEAD, INVULNERABLE, INIT}
var current_state: state = state.INIT

func change_state(new_state: state):
	if current_state == new_state:
		return
		
	match new_state:
		state.IDLE:
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.modulate.a = 1
			$CollisionShape2D.set_deferred("disabled", false)
			animated_sprite_2d.play("Idle")
		state.WALK:
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.modulate.a = 1
			$CollisionShape2D.set_deferred("disabled", false)
			animated_sprite_2d.play("Walking")
		state.JUMP:
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.modulate.a = 1
			$CollisionShape2D.set_deferred("disabled", false)
			animated_sprite_2d.play("Walking")
		state.DEAD:
			$AnimatedSprite2D.visible = false
			$AnimatedSprite2D.modulate.a = 1
			$CollisionShape2D.set_deferred("disabled", true)
		state.INVULNERABLE:
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.modulate.a = 0.5
			$CollisionShape2D.set_deferred("disabled", true)
			$InvulnerabilityTimer.start()
		state.INIT:
			$CollisionShape2D.set_deferred("disabled", true)
			$AnimatedSprite2D.modulate.a = 1
			$AnimatedSprite2D.visible = false
			
	current_state = new_state

func hurt(amount: int = 1):
	health -= amount

func _ready():
	change_state(state.INIT)

func reset():
	health = max_health
	change_state(state.IDLE)

func update_gravity():
	gravity_dir = (position - gravity_center).normalized()
	up_direction = -gravity_dir

func is_on_usable_doublejump_orb():
	for orb in inside_doublejump_orb_list:
		if orb.use():
			return true
	return false

func handle_inputs():
	if current_state == state.DEAD || current_state == state.INIT || current_state == state.INVULNERABLE:
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") && (is_on_floor() || is_on_usable_doublejump_orb()):
		change_state(state.JUMP)
		down_force = -JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		change_state(state.WALK)
		animated_sprite_2d.flip_h = direction == -1
		side_force = direction * SPEED
	else:
		if current_state != state.JUMP:
			change_state(state.IDLE)
		side_force = 0

func _physics_process(delta):
	update_gravity()
	
	handle_inputs()
		# Add the gravity.
	if not is_on_floor():
		down_force += gravity_scalar * delta
	elif current_state == state.JUMP:
		change_state(state.IDLE)

	
	velocity = gravity_dir * down_force + gravity_dir.orthogonal() * side_force
	move_and_slide()

func _process(delta):
	rotation = gravity_dir.angle() - PI/2

func _on_invulnerability_timer_timeout():
	change_state(state.IDLE)
