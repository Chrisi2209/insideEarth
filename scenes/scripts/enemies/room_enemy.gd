extends BaseEnemy
class_name RoomEnemy

@export var room: Room
var going_right = true

var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")

func walk(delta):
	var gravity_direction = (global_position - room.center).normalized()
	up_direction = -gravity_direction
	$AnimatedSprite2D.flip_h = going_right
	var walking_direction = gravity_direction.orthogonal() * (int(going_right) * 2 - 1)
	rotation = gravity_direction.angle() - PI/2
	
	velocity = walking_direction * speed
	if not is_on_floor():
		gravity_scalar * gravity_direction.normalized()
	
	move_and_slide()
	
	if get_slide_collision_count() > 1:
		going_right = not going_right
