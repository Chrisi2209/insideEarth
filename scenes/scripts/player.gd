extends CharacterBody2D

class_name Player

# physics
@export var SPEED = 400.0
@export var JUMP_VELOCITY = 400.0
var accel: float = 1500
var midair_accel: float = 500
var friction: float = 1000
var midair_friction: float = 50
var counter_created_friction: float = 300

var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_dir = Vector2(0, 1)
var down_force: float
var side_force: float
@export var gravity_center: Vector2

# nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D
@onready var camera = $Camera2D
@onready var fade_rect = $Camera2D/FadeRect
@onready var pickaxe = $Pickaxe

# double jump orb
var inside_doublejump_orb_list: Array = []

# door
var inside_door: Door = null
var pickaxe_inside_door: Door = null

# items
@onready var doublejump_item: DoublejumpItem = $DoublejumpItem
@onready var dash_item: DashItem = $DashItem
var dash_velocity: Vector2 = Vector2.ZERO

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
enum state {IDLE, WALK, JUMP, DEAD, INVULNERABLE, INIT, DASH, ATTACK}
var current_state: state = state.INIT
var last_state: state = state.INIT

func change_state(new_state: state):
	if current_state == new_state:
		return
	animated_sprite_2d.position.x = 0
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
			animated_sprite_2d.play("Jumping")
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
		state.ATTACK:
			animated_sprite_2d.play("Attacking")
			animated_sprite_2d.animation_finished.connect(_on_attack_finished)
			
	current_state = new_state

func hurt(amount: int = 1):
	health -= amount

func _ready():
	$Pickaxe.player = self
	change_state(state.INIT)

func reset():
	health = max_health
	change_state(state.IDLE)

func update_gravity():
	gravity_dir = (position - gravity_center).normalized()
	up_direction = -gravity_dir
		

func jump_if_on_usable_doublejump_orb():
	for orb in inside_doublejump_orb_list:
		if orb.usable:
			# high priority
			jump(orb, 10)

var jumper = []

func state_guard(forbidden_states: Array[state]):
	for forbidden in forbidden_states:
		if current_state == forbidden:
			return true
	return false

func end_dash():
	if is_on_floor():
		change_state(state.IDLE)
	else:
		change_state(state.JUMP)

func jump(source: Object, priority: int = 0):
	# depending on the source what triggers the jump, the priority is used to determine who should perform the jump
	# source has to implement function triggered_jump()
	# also returns if the player is already jumping this frame
	if state_guard([state.DEAD, state.INIT, state.ATTACK]):
		return
	if jumper.is_empty():
		jumper = [source, priority]
		call_deferred("execute_jump")
	else:
		if jumper[1] < priority:
			jumper = [source, priority]

func execute_jump():
	change_state(state.JUMP)
	down_force = -JUMP_VELOCITY
	jumper[0].triggered_jump()
	jumper = []

func triggered_jump():
	# jumping has no effect if triggered by the player
	pass

func get_current_friction():
	if is_on_floor():
		return friction
	else:
		return midair_friction
		
func get_current_accel():
	if is_on_floor():
		return accel
	else:
		return midair_accel

func handle_inputs(delta: float):
	if state_guard([state.DEAD, state.INIT, state.INVULNERABLE]):
		return
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if current_state != state.JUMP:
			# highest priority (cheapest)
			jump(self, 100000)
		else:
			jump_if_on_usable_doublejump_orb()
	
	if current_state == state.DASH:
		return

	var direction = Input.get_axis("left", "right")
	var speed_up = get_current_accel() * delta
	var slow_down = get_current_friction() * delta
	
	if direction:
		# pressing in a direction
		animated_sprite_2d.flip_h = direction == -1
		pickaxe.set_hitbox_side(animated_sprite_2d.flip_h)
		
		if current_state != state.JUMP && current_state != state.ATTACK:
			change_state(state.WALK)
		
		if sign(side_force) != sign(direction):
			side_force += direction * slow_down
			if abs(side_force) > SPEED:
				side_force += direction * counter_created_friction * delta
		side_force = clamp(side_force + (direction * speed_up), -SPEED, SPEED) if abs(side_force) <= SPEED else side_force - (slow_down * sign(side_force))
		
		
	else:
		# not pressing in a direction
		if current_state != state.JUMP && current_state != state.ATTACK:
			change_state(state.IDLE)
		
		# go towards 0
		side_force -= slow_down * sign(side_force)
		if abs(side_force) < slow_down:
			side_force = 0
			
	if Input.is_action_just_pressed("attack"):
		change_state(state.ATTACK)
	
	if Input.is_action_just_pressed("interact"):
		if inside_door != null:
			inside_door.go_through(self)

func update_directional_velocities():
	var alpha = gravity_dir.angle_to(velocity)
	down_force = velocity.length() * cos(alpha)
	side_force = -velocity.length() * sin(alpha)

func _physics_process(delta):
	update_gravity()
	# this has to be before handle_inputs
	
	# this has to be after handle_inputs
	if not is_on_floor():
		down_force += gravity_scalar * delta
	handle_inputs(delta)
	
	
	if current_state == state.ATTACK:
		if animated_sprite_2d.flip_h:
			animated_sprite_2d.position.x = -25
		else:
			animated_sprite_2d.position.x = 25
	else:
		animated_sprite_2d.position.x = 0

	if current_state == state.DASH:
		velocity = dash_velocity
	else:
		velocity = gravity_dir * down_force + gravity_dir.orthogonal() * side_force
		
	move_and_slide()
	update_directional_velocities()

func _process(delta):
	if is_on_floor() && last_state == state.JUMP:
		change_state(state.IDLE)
	rotation = gravity_dir.angle() - PI/2
	last_state = current_state

func _on_invulnerability_timer_timeout():
	change_state(state.IDLE)

func _on_attack_finished():
	change_state(state.IDLE)
	if pickaxe_inside_door != null:
		pickaxe_inside_door.break_stone()
