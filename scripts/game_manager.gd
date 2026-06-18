extends Node
var start_time : int
var gyro_gravity_enabled : bool = false

func get_gravity_vector() -> Vector2:
	if !gyro_gravity_enabled:
		return Vector2.DOWN

	var gravity : Vector3 = Input.get_gravity()
	var direction : Vector2 = Vector2(gravity.x, -gravity.y)
	if direction.length_squared() < 0.0001:
		var acceleration : Vector3 = Input.get_accelerometer()
		direction = Vector2(acceleration.x, -acceleration.y)
	if direction.length_squared() < 0.0001:
		return Vector2.DOWN
	return direction.normalized()
