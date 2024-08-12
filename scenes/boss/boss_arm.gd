extends Node2D
class_name BossArm

func fully_destroyed():
	for layer in get_children():
		if layer.health > 0:
			return false
	return true

func set_room_and_player(room: Room, player: Player):
	for layer in get_children():
		layer.room = room
		if layer is ShootingBossLayer:
			layer.player = player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
