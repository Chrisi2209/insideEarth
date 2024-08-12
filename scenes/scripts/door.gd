extends Area2D
class_name Door

@export var linked_door: Door
@export var state: states
var room: Room
@onready var dropoff = $DropoffMarker.global_position
@onready var cpu_particles_2d = $CPUParticles2D
@onready var timer = $CPUParticles2D/Timer

@onready var stone_door_texture = preload("res://assets/Door_blocked.png")
@onready var open_door_texture = preload("res://assets/Door.png")  
@onready var locked_door_texture = preload("res://assets/Door_locked.png")  

signal go_through_finished

enum states {STONE, LOCKED,OPEN}

func change_state(new_state):
	state = new_state
	match new_state:
		states.STONE:
			$Sprite2D.texture = stone_door_texture
		states.OPEN:
			$Sprite2D.texture = open_door_texture
		states.LOCKED:
			$Sprite2D.texture = locked_door_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func break_stone():
	if state == states.STONE:
		$BreakStoneSound.play()
		change_state(states.OPEN)
		cpu_particles_2d.emitting = true
		cpu_particles_2d.one_shot = true

func unlock():
	$UnlockSound.play()
	change_state(states.OPEN)

func go_through(player: Player):
	if state == states.LOCKED:
		if player.has_key():
			player.use_key()
			unlock()
			return
	
	
	if state != states.OPEN || player.current_state == Player.state.JUMP:
		return
		
	$EnterSound.play()
	player.reset_velocity()
	player.change_state(Player.state.CUT_SCENE)
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player.fade_rect, "color:a", 1, 0.5)
	if [self, linked_door] not in Global.door_pairs and [linked_door, self] not in Global.door_pairs:
		Global.door_pairs.append([self, linked_door])
	await tween.finished
	player.camera.turn_off_position_smoothing_for_frames(2)
	player.global_position = linked_door.dropoff
	player.room = linked_door.room
	linked_door.change_state(states.OPEN)
	await get_tree().create_timer(0.1).timeout
	go_through_finished.emit()
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

