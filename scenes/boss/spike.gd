extends Area2D
class_name Spike

var dead = false

func _process(delta):
	if not dead:
		for body in get_overlapping_bodies():
			if body is Player:
				body.hurt()


func _on_life_time_timeout():
	destroy()

func destroy():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "modulate:a", 0.5, 0.5)
	await tween.finished
	dead = true
	tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.5)
	await tween.finished
	queue_free()
	
