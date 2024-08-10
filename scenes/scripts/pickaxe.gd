extends Area2D
class_name Pickaxe

var player: Player
@export var damage: int = 1
@onready var start_hitbox_x_position = position.x

func on_door(door: Door):
	player.on_door(door)

func left_door():
	player.left_door()
	
func set_hitbox_side(side: bool):
	position.x = start_hitbox_x_position * (int(not side) * 2 - 1)

func attack():
	for body in get_overlapping_bodies():
		if body is BaseEnemy:
			body.hurt(damage)
	
	for area in get_overlapping_areas():
		if area is Door:
			area.break_stone()
			
