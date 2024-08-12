extends Node2D
class_name BossController

@export var torque = PI / 30
@export var room: Room
@export var player: Player
@onready var arms: Array[BossArm] = [$BossArmBottom, $BossArmLeft, $BossArmTop, $BossArmRight]
var bottom_dead = false
var left_dead = false
var top_dead = false
var right_dead = false
var key = preload("res://scenes/key.tscn")
var destroyed = false
var do_nothing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")
	for arm in arms:
		arm.set_room_and_player(room, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if do_nothing:
		return
	if not destroyed and not $BossMusic.playing and player.room == room:
		$BossMusic.play()
	elif destroyed || player.room != room:
		$BossMusic.stop()
		
	
	if $BossArmBottom.fully_destroyed() && not bottom_dead:
		player.heal(1)
		bottom_dead = true
	if $BossArmRight.fully_destroyed() && not right_dead:
		player.heal(1)
		right_dead = true
	if $BossArmLeft.fully_destroyed() && not left_dead:
		player.heal(1)
		left_dead = true
	if $BossArmTop.fully_destroyed() && not top_dead:
		player.heal(1)
		top_dead = true
	
	# rotation += torque * delta
	if is_destroyed():
		var destroyed = false
		destroy()
		
func destroy():
	if do_nothing:
		return
	$AnimationPlayer.play("destroy")
	

func is_destroyed() -> bool:
	for arm in arms:
		if not arm.fully_destroyed():
			return false
	return true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		do_nothing = true
		await get_tree().create_timer(3).timeout
		player.add_child(key.instantiate())
		$GetKey.play()
		await $GetKey.finished
		queue_free()
