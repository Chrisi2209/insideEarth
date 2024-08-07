extends StaticBody2D

# Parameters for the ring shape
@export var inner_radius: float = 50
var sides: int = round(inner_radius)

# Initialize the ring shape
func _ready():
	var collision_polygon = CollisionPolygon2D.new()
	
	var ring_points = generate_ring_points(inner_radius + 50, sides)
	var hole_points = generate_ring_points(inner_radius, sides, true)
	var points = ring_points + hole_points

	collision_polygon.polygon = points
	add_child(collision_polygon)

# Function to generate points for the ring
func generate_ring_points(radius, sides, reverse=false):
	var points = []
	var angle_step = PI * 2 / sides
	
	for i in range(sides):
		var angle = angle_step * i
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# close the shape with /1000 precision (there will be a 1 thousands gap)
	points.append(Vector2(cos(-angle_step / 1000), sin(-angle_step / 1000)) * radius)
		
	if reverse:
		points.reverse()
		
	return points
