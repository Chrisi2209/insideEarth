extends Node2D
class_name BossController

@export var torque = PI / 30
@export var room: Room
@export var player: Player
@onready var arms: Array[BossArm] = [$BossArmBottom, $BossArmLeft, $BossArmTop, $BossArmRight]
var bottom_dead = false
var left_dead = false
var top_dead = false
var right = false
var key = preload("res://scenes/key.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")
	for arm in arms:
		arm.set_room_and_player(room, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $BossArmBottom.fully_destroyed():
		player.heal(1)
	
	# rotation += torque * delta
	if is_destroyed():
		destroy()
		
func destroy():
	$AnimationPlayer.play("destroy")
	

func is_destroyed() -> bool:
	for arm in arms:
		if not arm.fully_destroyed():
			return false
	return true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		player.add_child(key.instantiate())
		$GetKey.play()
		queue_free()
