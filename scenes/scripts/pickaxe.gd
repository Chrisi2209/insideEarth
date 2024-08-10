extends Area2D
class_name Pickaxe
@onready var attack_particle = $Attack_Particle

var player: Player
<<<<<<<< Updated upstream:scenes/scripts/Pickaxe.gd
@onready var start_hitbox_x_position = $CollisionShape2D.position.x
========
@onready var start_hitbox_x_position = position.x
@onready var start_hitbox_x_position_particle = attack_particle.position.x
>>>>>>>> Stashed changes:scenes/scripts/pickaxe.gd

func on_door(door: Door):
	player.on_door(door)

func left_door():
	player.left_door()
	
func set_hitbox_side(side: bool):
<<<<<<<< Updated upstream:scenes/scripts/Pickaxe.gd
	$CollisionShape2D.position.x = start_hitbox_x_position * (int(not side) * 2 - 1)
========
	position.x = start_hitbox_x_position * (int(not side) * 2 - 1)
	attack_particle.position.x = start_hitbox_x_position_particle * (int(not side) * 2 - 1)
>>>>>>>> Stashed changes:scenes/scripts/pickaxe.gd
