extends Node
var start_time : int
var gyro_gravity_enabled : bool = false
const MIN_VALID_SENSOR_VECTOR_LENGTH_SQUARED : float = 0.0001

func get_gravity_vector() -> Vector2:
	if !gyro_gravity_enabled:
		return Vector2.DOWN

	var gravity : Vector3 = Input.get_gravity()
	# Sensor Y points up, while Godot's 2D Y axis points down.
	var direction : Vector2 = Vector2(gravity.x, -gravity.y)
	if direction.length_squared() < MIN_VALID_SENSOR_VECTOR_LENGTH_SQUARED:
		var acceleration : Vector3 = Input.get_accelerometer()
		direction = Vector2(acceleration.x, -acceleration.y)
	if direction.length_squared() < MIN_VALID_SENSOR_VECTOR_LENGTH_SQUARED:
		return Vector2.DOWN
	return direction.normalized()
