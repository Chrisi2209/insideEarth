extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 300
@export var max_health = 1
var health: int = max_health: set = set_health

func set_health(value):
	health = value
	if health <= 0:
		die()
	else:
		hit_animation()

func die():
	queue_free()

func hit_animation():
	pass

func hurt(amount: int = 1):
	health -= amount

var players_inside = []

func _on_area_2d_body_entered(body):
	if body is Player:
		players_inside.append(body)

func _on_area_2d_body_exited(body):
	if body is Player:
		players_inside.erase(body)

func walk(delta):
	assert(false)

func get_side_force(gravity_dir):
	var alpha = gravity_dir.angle_to(velocity)
	return -velocity.length() * sin(alpha)

func _physics_process(delta):
	walk(delta)
	
	for player in players_inside:
		player.hurt()
