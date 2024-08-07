extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = 400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_scalar = 2000# ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_dir = Vector2(0, 1)
var gravity: Vector2
@export var gravity_center: Vector2

func update_gravity():
	gravity_dir = (position - gravity_center).normalized()
	up_direction = -gravity_dir
	gravity = gravity_dir * gravity_scalar


func _physics_process(delta):
	update_gravity()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += -gravity_dir * 500

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, gravity_dir.orthogonal().x * direction * SPEED, SPEED * delta) 
		velocity.y = move_toward(velocity.y, gravity_dir.orthogonal().y * direction * SPEED, SPEED * delta) 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()

func _process(delta):
	rotation = gravity_dir.angle() - PI/2
