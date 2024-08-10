extends Area2D
class_name DoublejumpOrb
@onready var cpu_particles_2d = $CPUParticles2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var usable = true: set = set_usable

func set_usable(usable_: bool):
	if usable_ == false:
		$Cooldown.start()
		
	usable = usable_
	if usable:
		animated_sprite_2d.play("ready")
	else:
		animated_sprite_2d.play("used")

func triggered_jump():
	cpu_particles_2d.emitting = true
	cpu_particles_2d.one_shot = true
	usable = false
	
func _on_cooldown_timeout():
	usable = true
	
func _on_body_entered(body):
	if body is Player:
		(body as Player).inside_doublejump_orb_list.append(self)

func _on_body_exited(body):
	if body is Player:
		(body as Player).inside_doublejump_orb_list.erase(self)

