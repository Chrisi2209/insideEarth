extends Area2D
class_name DoublejumpOrb

var usable = true: set = set_usable

func set_usable(usable_: bool):
	usable = usable_
	if usable:
		$Sprite2D.modulate.a = 1
	else:
		$Sprite2D.modulate.a = 0.2
		
func use() -> bool:
	# Returns true when usable, false when not
	if usable:
		usable = false
		$Cooldown.start()
		return true
	return false
	
func _on_cooldown_timeout():
	usable = true
	
func _on_body_entered(body):
	if body is Player:
		(body as Player).inside_doublejump_orb_list.append(self)

func _on_body_exited(body):
	if body is Player:
		(body as Player).inside_doublejump_orb_list.erase(self)

