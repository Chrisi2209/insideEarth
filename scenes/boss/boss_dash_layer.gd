extends BossLayer
class_name DashBossLayer

signal dashing

var from_left: bool
@onready var dropoff_left = $DropoffLeft.global_position
@onready var dropoff_right = $DropoffRight.global_position
@onready var dash_distance = (dropoff_left - dropoff_right).length()
var animation_duration = 0.5  # in animation player also change

func _ready():
	super._ready()
	
func _process(delta):
	super._process(delta)
	if dead:
		$Sprite2D.frame = 10
		
	for body in $DashHitboxLeft.get_overlapping_bodies():
		if body is Player:
			if body.current_state == Player.state.DASH:
				dash_through(body, true)
	
	for body in $DashHitboxRight.get_overlapping_bodies():
		if body is Player:
			if body.current_state == Player.state.DASH:
				dash_through(body, false)
				


func dash_through(player: Player, from_left_: bool):
	dashing.emit()
	
	from_left = from_left_
	if from_left:
		$DashAnimationPlayer.play("dash_through")
	else:
		$DashAnimationPlayer.play_backwards("dash_through")
		
	player.deactivate_collision()
	player.visible = false
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player, "global_position", get_dropoff_for_direction(from_left), animation_duration)
	await tween.finished
	$DashAnimationPlayer.play("RESET")
	player.activate_collision()
	player.visible = true


func get_dropoff_for_direction(from_left):
	if from_left:
		return dropoff_right
	else:
		return dropoff_left
		


func _on_died():
	$Sprite2D.frame = 10
