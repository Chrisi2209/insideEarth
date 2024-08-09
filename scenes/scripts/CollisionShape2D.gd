extends CollisionShape2D


func create_circumference_polygon(radius, thickness, segments):
	var polygon = []
	for i in range(segments):
		var angle = (PI * 2 / segments) * i
		var outer_point = Vector2(radius * cos(angle), radius * sin(angle))
		var inner_point = Vector2((radius - thickness) * cos(angle), (radius - thickness) * sin(angle))
		polygon.append(outer_point)
		polygon.append(inner_point)
	return polygon
