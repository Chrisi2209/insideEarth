extends Area2D
class_name Missle

var direction: Vector2
@export var speed: float = 100
@export var torque: float = 1.5
@export var player_to_follow: Player
@export var room: Room
var gravity_scalar = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead = true

func start(player: Player, speed_: float, direction_: Vector2, torque_: float, position_: Vector2, room_: Room):
	dead = false
	room = room_
	player_to_follow = player
	global_position = position_
	direction = direction_
	speed = speed_
	torque = torque_
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")

func update_velocity(delta):
	var distance_to_left = ($MarkerLeft.global_position - player_to_follow.global_position).length()
	var distance_to_right = ($MarkerRight.global_position - player_to_follow.global_position).length()
	
	if distance_to_left < distance_to_right:
		# turn left
		direction = direction.rotated(-torque * delta).normalized()
	elif distance_to_right < distance_to_left:
		# turn right
		direction = direction.rotated(torque * delta).normalized()

func angle_Pi_to_Pi(angle: float):
	var new_angle = angle
	while new_angle > PI:
		new_angle -= 2 * PI
	while new_angle < -PI:
		new_angle += 2 * PI
	return new_angle

func _process(delta):
	if not dead:
		update_velocity(delta)
		rotation = direction.angle()
		position += direction * speed * delta
		for body in get_overlapping_bodies():
			if body is Player:
				body.hurt()
				destroy()
			if body.is_in_group("destroys_missle"):
				destroy()
		
		for area in get_overlapping_areas():
			if area.is_in_group("destroys_missle"):
				destroy()

func destroy():
	dead = true
	emit_particle_wave(0.1)
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true
	await $CPUParticles2D/ParticleBurstTimer.timeout
	await get_tree().create_timer(1).timeout
	queue_free()

func emit_particle_wave(duration: float):
	$CPUParticles2D.gravity = (global_position - room.center).normalized() * gravity_scalar
	$CPUParticles2D.emitting = true
	$CPUParticles2D/ParticleBurstTimer.start(duration)

func stop_particle_wave():
	$CPUParticles2D.emitting = false

func _on_life_timer_timeout():
	$AnimationPlayer.play("dying")
	await $AnimationPlayer.animation_finished
	print("realydying")
	destroy()


func _on_spawn_protection_timeout():
	$CollisionShape2D.disabled = false
