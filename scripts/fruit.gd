extends RigidBody2D
class_name Fruit
var released : bool = true
var gravity_acceleration : float = 0.0
var gyro_gravity_active : bool = false

func _ready() -> void:
	gravity_acceleration = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
	GameManager.gyro_gravity_changed.connect(_on_gyro_gravity_changed)
	_on_gyro_gravity_changed(GameManager.gyro_gravity_enabled)

func _on_gyro_gravity_changed(enabled: bool) -> void:
	gyro_gravity_active = enabled
	gravity_scale = 0.0 if enabled else 1.0

func _physics_process(delta: float) -> void:
	if freeze or !released:
		return
	if gyro_gravity_active:
		linear_velocity += GameManager.gravity_vector * gravity_acceleration * delta
