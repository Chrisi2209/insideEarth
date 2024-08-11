extends Platform
class_name CenterRotatedPlatform


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	rotate_appropriately()

func rotate_appropriately():
	rotation = (room.center - global_position).angle() + PI / 2.

