extends BossLayer
class_name DamagingBossLayer

func _process(delta):
	if not dead:
		for body in $Hitbox.get_overlapping_bodies():
			if body is Player:
				body.hurt()

func _on_died():
		$Sprite2D.frame = 1
