extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.gravity_center = $Room.center
	$Player.reset()
	$Player.current_room = $Room


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
