extends CharacterBody2D

class_name Player

# physics
@export var SPEED = 400.0
@export var JUMP_VELOCITY = 400.0
var accel: float = 1500
var midair_accel: float = 500
var friction: float = 1800
var midair_friction: float = 50
var counter_created_friction: float = 300

var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_dir = Vector2(0, 1)
var down_force: float
var side_force: float
var gravity_center: Vector2
@export var room: Room

# nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D
@onready var camera = $Camera2D
@onready var fade_rect = $Camera2D/FadeRect
@onready var jump_particle = $Jump_Particle
@onready var attack_particle = $Pickaxe/Attack_Particle
@onready var double_jump_particle = $Double_Jump_Particle


# double jump orb
var inside_doublejump_orb_list: Array = []

# door
var inside_door: Door = null

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
		
	health_changed.emit(health)

# states
enum state {IDLE, WALK, JUMP, DEAD, INIT, DASH, ATTACK, CUT_SCENE}
var current_state: state = state.INIT
var last_state: state = state.INIT

func change_state(new_state: state):
	if current_state == new_state:
		return
	animated_sprite_2d.position.x = 0
	match new_state:
		state.IDLE:
			$AnimatedSprite2D.visible = true
			animated_sprite_2d.play("Idle")
		state.WALK:
			$AnimatedSprite2D.visible = true
			animated_sprite_2d.play("Walking")
		state.JUMP:
			$AnimatedSprite2D.visible = true
			animated_sprite_2d.play("Jumping")
		state.DEAD:
			$AnimatedSprite2D.visible = false
			animated_sprite_2d.play("Dead")
		state.INIT:
			$AnimatedSprite2D.visible = false
		state.CUT_SCENE:
			$AnimatedSprite2D.visible = true
			animated_sprite_2d.play("Idle")
		state.ATTACK:
			animated_sprite_2d.play("Attacking")
			animated_sprite_2d.animation_finished.connect(_on_attack_finished)
			#attack_particle.emitting = true
			#attack_particle.one_shot = true
			
	current_state = new_state

var invulnerable = false: set = set_invulnerable

func set_invulnerable(value: bool):
	invulnerable = value
	if value:
		$InvulnerabilityTimer.start()

func hurt(amount: int = 1):
	if invulnerable:
		return
	health -= amount
	invulnerable = true
	
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.modulate.a = 0.5
	$InvulnerabilityTimer.start()

func _ready():
	change_state(state.INIT)

func reset():
	health = max_health
	change_state(state.IDLE)

func update_gravity():
	gravity_dir = (global_position - gravity_center).normalized()
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
	if state_guard([state.DEAD, state.INIT, state.ATTACK]):
		return
	if jumper.is_empty():
		jumper = [source, priority]
		call_deferred("execute_jump")
	else:
		if jumper[1] < priority:
			jumper = [source, priority]
	if state.JUMP:
		jump_particle.emitting = true
		jump_particle.one_shot = true

func execute_jump():
	change_state(state.JUMP)
	down_force = -JUMP_VELOCITY
	jumper[0].triggered_jump()
	jumper = []
	jump_particle.emitting = true
	jump_particle.one_shot = true

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
	if state_guard([state.DEAD, state.INIT, state.CUT_SCENE]):
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
		
		if $Pickaxe != null:
			$Pickaxe.set_hitbox_side(animated_sprite_2d.flip_h)
		
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
			
	if Input.is_action_just_pressed("attack") && $Pickaxe != null:
		change_state(state.ATTACK)
	
	if Input.is_action_just_pressed("interact"):
		if inside_door != null:
			inside_door.go_through(self)
			inside_door.go_through_finished.connect(_on_door_entered)

func has_key():
	return $Key != null

func use_key():
	$Key.queue_free()

func update_directional_velocities():
	var alpha = gravity_dir.angle_to(velocity)
	down_force = velocity.length() * cos(alpha)
	side_force = -velocity.length() * sin(alpha)

func adjust_position_for_attacking_sprite():
	if current_state == state.ATTACK:
		if animated_sprite_2d.flip_h:
			animated_sprite_2d.position.x = -25
		else:
			animated_sprite_2d.position.x = 25
	else:
		animated_sprite_2d.position.x = 0

func reset_velocity():
	velocity = Vector2.ZERO
	side_force = 0
	down_force = 0

func _physics_process(delta):
	update_gravity()
	
	if current_state == state.DEAD:
		if not is_on_floor():
			down_force += gravity_scalar * delta
		else:
			reset_velocity()
		
		velocity = gravity_dir * down_force + gravity_dir.orthogonal() * side_force
		move_and_slide()
		return
	
	handle_inputs(delta)
	
	if not is_on_floor():
		down_force += gravity_scalar * delta
		if down_force > 0.05 * gravity_scalar && current_state != state.DASH:
			change_state(state.JUMP)
	
	adjust_position_for_attacking_sprite()

	if current_state == state.DASH:
		velocity = dash_velocity
	else:
		velocity = gravity_dir * down_force + gravity_dir.orthogonal() * side_force
	
	move_and_slide()
	update_directional_velocities()

func _process(delta):
	if is_on_floor() && last_state == state.JUMP:
		change_state(state.IDLE)
	
	gravity_center = room.center
	rotation = gravity_dir.angle() - PI/2
	last_state = current_state

func _on_invulnerability_timer_timeout():
	animated_sprite_2d.modulate.a = 1
	invulnerable = false

func _on_attack_finished():
	if is_on_floor():
		change_state(state.IDLE)
	else:
		change_state(state.JUMP)
	$Pickaxe.attack()

func _on_door_entered():
	change_state(state.IDLE)
