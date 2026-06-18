extends RigidBody2D
class_name Fruit
var released : bool = true
const DEFAULT_GRAVITY_ACCELERATION : float = 980.0

func _physics_process(delta: float) -> void:
	if freeze or !released:
		return
	if GameManager.gyro_gravity_enabled:
		gravity_scale = 0.0
		linear_velocity += GameManager.gravity_vector * DEFAULT_GRAVITY_ACCELERATION * delta
	else:
		gravity_scale = 1.0
