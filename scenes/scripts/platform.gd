extends StaticBody2D
class_name Platform
"""
func get_up_direction(other_position: Vector2):
	var my_position = global_position
	
	
	var half_width: Vector2 = Vector2.from_angle(rotation) * $CollisionShape2D.shape.size.x / 2
	var half_height: Vector2 = Vector2.from_angle(rotation + PI / 2) * $CollisionShape2D.shape.size.y / 2
	
	
	var angle_top_left = my_position.angle_to(my_position - half_width - half_height)
	if angle_top_left < 0:
		angle_top_left += 2 * PI
	var angle_bottom_left = my_position.angle_to(my_position - half_width + half_height)
	if angle_bottom_left < 0:
		angle_bottom_left += 2 * PI
	var angle_top_right = my_position.angle_to(my_position + half_width - half_height)
	if angle_top_right < 0:
		angle_top_right += 2 * PI
	var angle_bottom_right = my_position.angle_to(my_position + half_width + half_height)
	if angle_bottom_right < 0:
		angle_bottom_right += 2 * PI
	
	var alpha = my_position.angle_to(other_position)
	if alpha < 0:
		alpha += 2 * PI
	
	if angle_in_range(alpha, angle_top_right, angle_top_left):
		# up
		return Vector2.from_angle(rotation + PI / 2)
	if angle_in_range(alpha, angle_top_left, angle_bottom_left):
		# left
		
		return Vector2.from_angle(rotation + PI)
	if angle_in_range(alpha, angle_bottom_left, angle_bottom_right):
		# down		
		
		return Vector2.from_angle(rotation - PI / 2)
	if angle_in_range(alpha, angle_bottom_right, angle_top_right):
		# right
		
		return Vector2.from_angle(rotation)
	
	return Vector2.DOWN

func angle_in_range(angle: float, from: float, to: float):
	if from > to:
		return angle > from && angle > to
	
	return from < angle && angle < to
"""
