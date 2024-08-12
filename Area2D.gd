extends Area2D

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		for body in get_overlapping_bodies():
			if body is Player:
				print("hi")
