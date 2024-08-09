extends Area2D
class_name Pickaxe

var player: Player
@onready var start_hitbox_x_position = $CollisionShape2D.position.x

func on_door(door: Door):
	player.on_door(door)

func left_door():
	player.left_door()
	
func set_hitbox_side(side: bool):
	$CollisionShape2D.position.x = start_hitbox_x_position * (int(not side) * 2 - 1)
