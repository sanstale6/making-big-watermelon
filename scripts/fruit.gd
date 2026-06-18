extends RigidBody2D
class_name Fruit
var released : bool = true
var gravity_acceleration : float = 980.0

func _ready() -> void:
	gravity_acceleration = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func _physics_process(delta: float) -> void:
	if freeze or !released:
		return
	if GameManager.gyro_gravity_enabled:
		gravity_scale = 0.0
		linear_velocity += GameManager.gravity_vector * gravity_acceleration * delta
	else:
		gravity_scale = 1.0
