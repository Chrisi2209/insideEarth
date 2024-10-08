@tool
extends StaticBody2D
class_name Room

@export var inner_radius: float = 50
var sides: int = round(inner_radius) * 3
var center = global_position

func has_property(obj, property_name: String) -> bool:
	var property_list = obj.get_property_list()
	for property in property_list:
		if property["name"] == property_name:
			return true
	return false

func _ready():
	for child in get_children():
		if has_property(child, "room"):
			child.room = self
	
	# Create the collision polygon for the ring
	var collision_polygon = CollisionPolygon2D.new()
	
	var ring_points = generate_ring_points(inner_radius + 50, sides)
	var hole_points = generate_ring_points(inner_radius, sides, true)
	var points = ring_points + hole_points

	collision_polygon.polygon = points
	add_child(collision_polygon)


func _process(delta):
	center = global_position

# Function to generate points for the ring
func generate_ring_points(radius, sides, reverse=false):
	var points = []
	var angle_step = PI * 2 / sides
	
	for i in range(sides):
		var angle = angle_step * i
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# Close the shape with /1000 precision (there will be a 1 thousandth gap)
	points.append(Vector2(cos(-angle_step / 1000), sin(-angle_step / 1000)) * radius)
		
	if reverse:
		points.reverse()
		
	return points
