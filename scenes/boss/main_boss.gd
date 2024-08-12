extends AnimatableBody2D
class_name MainBoss

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead:
		for body in $Area2D.get_overlapping_bodies():
			if body is Player:
				body.hurt()
