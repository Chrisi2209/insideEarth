extends CharacterBody2D
class_name BaseEnemy

@export var speed: float = 300
@export var max_health: int = 1
var health: int = max_health: set = set_health
var dead = false
var invulnerable = false

func set_health(value):
	if value <= 0:
		die()
	elif value < health:
		invulnerable = true
		$AnimationPlayer.play("hurt")
		$DeathParticles.emitting = true
		await get_tree().create_timer(0.1).timeout
		$DeathParticles.emitting = false
	health = value

func die():
	$DeathParticles.emitting = true
	$AnimatedSprite2D.speed_scale = 0
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.5)
	dead = true
	await get_tree().create_timer(0.1).timeout
	$DeathParticles.emitting = false                                     
	await get_tree().create_timer(1).timeout                   
	queue_free()               

func hurt(amount: int = 1):
	if invulnerable:
		return
	$DamageSound.play()
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
	if dead:
		return
	walk(delta)
	
	for player in players_inside:
		player.hurt()

func _ready():
	health = max_health
	
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	invulnerable = false
