extends AnimatableBody2D
class_name BossLayer

@export var max_health: int = 3
var health: int: set = set_health
@export var dead: bool = false
@export var room: Room
var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_dir: Vector2
var invulnerable = false
@export var flip = false

signal died

func hit_animation():
	emit_particle_wave(0.1)
	$StateAnimationPlayer.play("hit")
	
func die():
	died.emit()
	emit_particle_wave(0.3)
	dead = true
	$StateAnimationPlayer.play("die")

func set_health(value: int):
	var new_value = value
	if value <= 0:
		new_value = 0
		if health > 0:
			die()
	elif value < health:
		# lost health
		$DamageSound.play()
		hit_animation()
		
	health = new_value


func _ready():
	if flip:
		$Sprite2D.flip_h = true
	if dead:
		died.emit()
		health = 0
	health = max_health

func _process(delta):
	pass

func hurt(damage: int):
	# returns if it could hurt
	if not invulnerable:
		invulnerable = true
		var old_health = health
		health -= 1
		return health != old_health
	return false

func emit_particle_wave(duration: float):
	gravity_dir = (global_position - room.center).normalized()
	$CPUParticles2D.gravity = gravity_scalar * gravity_dir
	$CPUParticles2D.emitting = true
	$CPUParticles2D/ParticleBurstTimer.start(duration)

func stop_particle_wave():
	$CPUParticles2D.emitting = false


func _on_state_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		invulnerable = false
