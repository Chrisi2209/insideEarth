extends BaseEnemy
class_name PlatformEnemy

@export var platform: Platform

var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var going_right = true

func update_going_right():
	if going_right:
		if ($BottomRight.global_position - platform.global_position).length() >= platform.diameter / 2:
			going_right = false
	else:
		if ($BottomLeft.global_position - platform.global_position).length() >= platform.diameter / 2:
			going_right = true

func walk(delta):
	var gravity_direction = Vector2.from_angle(platform.rotation + PI / 2)
	up_direction = -gravity_direction
	
	
	update_going_right()
	
	$AnimatedSprite2D.flip_h = not going_right
	var walking_direction = gravity_direction.orthogonal() * (int(going_right) * 2 - 1)
	
	rotation = gravity_direction.angle() - PI/2
	
	velocity = walking_direction * speed
	
	if not is_on_floor():
		velocity += gravity_scalar * gravity_direction * delta
	move_and_slide()

	
	
	
