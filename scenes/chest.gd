extends Area2D

@export var treasure: PackedScene

@export var sprite_closed: Texture2D
@export var sprite_open: Texture2D

enum states {CLOSED, OPEN}
var state: states = states.CLOSED

func _ready():
	change_state(states.CLOSED)

func change_state(new_state: states):
	state = new_state
	match state:
		states.CLOSED:
			$Sprite2D.texture = sprite_closed
		states.OPEN:
			$Sprite2D.texture = sprite_open

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
