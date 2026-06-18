extends RigidBody2D
class_name Fruit
var is_released : bool = true
var gravity_acceleration : float = 0.0
var gyro_gravity_active : bool = false

func _ready() -> void:
	if ProjectSettings.has_setting("physics/2d/default_gravity"):
		gravity_acceleration = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
	else:
		gravity_acceleration = 980.0
	GameManager.gyro_gravity_changed.connect(_on_gyro_gravity_changed)
	_on_gyro_gravity_changed(GameManager.gyro_gravity_enabled)

func _on_gyro_gravity_changed(enabled: bool) -> void:
	gyro_gravity_active = enabled
	gravity_scale = 0.0 if enabled else 1.0

func _physics_process(delta: float) -> void:
	if freeze or !is_released:
		return
	if gyro_gravity_active:
		# Keep the default gravity strength and only rotate its direction.
		linear_velocity += GameManager.get_current_gravity_vector() * gravity_acceleration * delta
