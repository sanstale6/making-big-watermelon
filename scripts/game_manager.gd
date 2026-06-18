extends Node
signal gyro_gravity_changed(enabled: bool)

var start_time : int
var _gyro_gravity_enabled : bool = false
var gyro_gravity_enabled : bool:
	get:
		return _gyro_gravity_enabled
	set(value):
		if _gyro_gravity_enabled == value:
			return
		_gyro_gravity_enabled = value
		if !value:
			_gravity_vector = Vector2.DOWN
		gyro_gravity_changed.emit(value)
var _gravity_vector : Vector2 = Vector2.DOWN
# Ignore tiny readings so a resting device doesn't jitter the gravity direction.
const SENSOR_MIN_LENGTH_SQ : float = 0.0001

func _physics_process(_delta: float) -> void:
	if !gyro_gravity_enabled:
		return
	_gravity_vector = get_gravity_vector()

func get_gravity_vector() -> Vector2:
	var gravity : Vector3 = Input.get_gravity()
	# Sensor Y points up, while Godot's 2D Y axis points down.
	var direction : Vector2 = Vector2(gravity.x, -gravity.y)
	if direction.length_squared() < SENSOR_MIN_LENGTH_SQ:
		var acceleration : Vector3 = Input.get_accelerometer()
		direction = Vector2(acceleration.x, -acceleration.y)
		if direction.length_squared() < SENSOR_MIN_LENGTH_SQ:
			return Vector2.DOWN
	return direction.normalized()

func get_current_gravity_vector() -> Vector2:
	return _gravity_vector
