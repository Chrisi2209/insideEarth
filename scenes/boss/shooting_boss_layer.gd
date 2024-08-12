extends DamagingBossLayer
class_name ShootingBossLayer

@export var player: Player
@export var min_shoot_delay: float = 2
@export var max_shoot_delay: float = 5
@export var missle_speed: float = 100
@export var missle_torque: float = 1.5
var missle_scene = preload("res://scenes/boss/missle.tscn")
var spike_scene = preload("res://scenes/boss/spike.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if min_shoot_delay > max_shoot_delay:
		assert(false)
	start_shoot_process()

func start_shoot_process():
	$ShootTimer.start(randf_range(min_shoot_delay, max_shoot_delay))

func _process(delta):
	super._process(delta)

func _on_shoot_timer_timeout():
	if not dead:
		start_shoot_process()
		if randf() > 0.5:
			shoot_left()
		else:
			shoot_right()
	
func shoot_left():
	if not dead:
		$ShootAnimationPlayer.play("shoot_left")
		$ShootDelay.start()
		await $ShootDelay.timeout
		spawn_missle()

func spawn_missle():
	if not dead:
		var missle = missle_scene.instantiate() as Missle
		missle.start(player, missle_speed, Vector2.from_angle(global_rotation + PI), missle_torque, $MissleSpawnPoint.global_position, room)
		get_tree().root.add_child(missle)

func shoot_right():
	if not dead:
		$ShootAnimationPlayer.play("shoot_right")
		$ShootDelay.start()
		await $ShootDelay.timeout
		spawn_spike()

func spawn_spike():
	if not dead:
		var spike = spike_scene.instantiate()
		spike.position = $SpikeSpawnPoint.position
		add_child(spike)

func _on_died():
	pass
