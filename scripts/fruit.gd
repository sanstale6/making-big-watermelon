extends RigidBody2D
class_name Fruit
var released : bool = true
const GRAVITY : float = 980.0

func _ready() -> void:
	gravity_scale = 0.0

func _physics_process(delta: float) -> void:
	if freeze or !released:
		return
	linear_velocity += GameManager.get_gravity_vector() * GRAVITY * delta
