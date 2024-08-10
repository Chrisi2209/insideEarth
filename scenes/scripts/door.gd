extends Area2D
class_name Door

@export var linked_door: Door
@export var state: states
@onready var dropoff = $DropoffMarker.global_position

@onready var stone_door_texture = preload("res://assets/Door_blocked.png")
@onready var open_door_texture = preload("res://assets/Door.png")  

enum states {STONE, OPEN}

func change_state(new_state):
	state = new_state
	match new_state:
		states.STONE:
			$Sprite2D.texture = stone_door_texture
		states.OPEN:
			$Sprite2D.texture = open_door_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func break_stone():
	if state == states.STONE:
		change_state(states.OPEN)

func go_through(player: Player):
	if state != states.OPEN:
		return
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player.fade_rect, "color:a", 1, 0.5)
	await tween.finished
	player.camera.turn_off_position_smoothing_for_frames(2)
	player.position = linked_door.dropoff
	linked_door.change_state(states.OPEN)
	await get_tree().create_timer(0.1).timeout
	tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player.fade_rect, "color:a", 0, 0.5)
	await tween.finished

func _on_body_entered(body):
	if body is Player:
		body.inside_door = self

func _on_body_exited(body):
	if body is Player:
		if body.inside_door == self:
			body.inside_door = null

func _on_area_entered(area):
	if area is Pickaxe:
		area.player.pickaxe_inside_door = self

func _on_area_exited(area):
	if area is Pickaxe:
		if area.player.inside_door == self:
			area.player.pickaxe_inside_door = null
