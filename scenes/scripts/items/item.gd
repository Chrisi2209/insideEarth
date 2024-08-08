extends Node
class_name Item

@export var player: Player

func use():
	# Function that returns true if the item can be used and false if not.
	push_error("Trying to call abstract method Item.use()")
