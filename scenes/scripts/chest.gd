extends Area2D

@export var treasure: PackedScene

@onready var animated_sprite_2d = $AnimatedSprite2D

enum states {CLOSED, OPEN}
var state: states = states.CLOSED

func _ready():
	change_state(states.CLOSED)

func change_state(new_state: states):
	state = new_state
	var treasure_instance = treasure.instantiate()
	if treasure_instance is Pickaxe:
		match state:
			states.CLOSED:
				animated_sprite_2d.play("pickaxe_in_stone")
			states.OPEN:
				animated_sprite_2d.play("stone_no_pickaxe")
	if treasure_instance is DoublejumpItem:
		match state:
			states.CLOSED:
					animated_sprite_2d.play("double_jump_item")
			states.OPEN:
				animated_sprite_2d.play("nothing")
	if treasure_instance is DashItem:
		match state:
			states.CLOSED:
				animated_sprite_2d.play("dash_item")
			states.OPEN:
				animated_sprite_2d.play("nothing")
				
	if treasure_instance is Key:
		match state:
			states.CLOSED:
				animated_sprite_2d.play("key")
			states.OPEN:
				animated_sprite_2d.play("nothing")

func interact(player: Player):
	if state == states.CLOSED:
		var treasure_instance = treasure.instantiate()
		player.add_child(treasure_instance)
		if treasure_instance is DoublejumpItem or treasure_instance is DashItem:
			treasure_instance.player = player
		change_state(states.OPEN)

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for body in get_overlapping_bodies():
			if body is Player:
				interact(body)
