extends RigidBody2D
class_name Fruit
var released : bool = true
var gravity_acceleration : float = 980.0
var gyro_gravity_active : bool = false

func _ready() -> void:
	gravity_acceleration = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func _physics_process(delta: float) -> void:
	if freeze or !released:
		return
	if gyro_gravity_active != GameManager.gyro_gravity_enabled:
		gyro_gravity_active = GameManager.gyro_gravity_enabled
		gravity_scale = 0.0 if gyro_gravity_active else 1.0

	if gyro_gravity_active:
		linear_velocity += GameManager.gravity_vector * gravity_acceleration * delta
