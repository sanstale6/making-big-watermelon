extends Node2D
class_name FruitComponent

@export var fruit : Fruit
@export var collision : CollisionShape2D
@export var fruit_id : String
@export var detect_area : Area2D
@export_file var target_fruit
@export var anim : AnimationPlayer
var making : bool = false
var pending_merge_target_id : int = 0
var removal_timer: SceneTreeTimer
@onready var detect_collision_shape : CollisionShape2D = detect_area.get_node('CollisionShape2D')
@onready var fruit_sprite : Sprite2D = fruit.get_node('Sprite2D')

func _ready() -> void:
	detect_area.body_entered.connect(collision_judge)
	target_fruit = load(target_fruit)
	


func collision_judge(body):
	if !body.is_in_group('fruit'):
		return
	if !fruit.is_released: return
	var target_fruit_component : FruitComponent = body.get_node('FruitComponent')
	if !target_fruit_component.fruit.is_released : return
	if !can_merge_with(target_fruit_component):
		return
	if get_instance_id() > target_fruit_component.get_instance_id():
		return
	reserve_merge(target_fruit_component)
	integrate(target_fruit_component)
		
func integrate(companion : FruitComponent) -> void:
	if !is_instance_valid(companion):
		pending_merge_target_id = 0
		return
	if !is_merge_reserved_with(companion):
		return
	pending_merge_target_id = 0
	companion.pending_merge_target_id = 0
	making = true
	companion.making = true
	disable_for_merge(self)
	disable_for_merge(companion)
	
	#var spawn_position = (get_parent().position + companion.get_parent().position)*0.5
	var spawn_position : Vector2 = fruit.position if fruit.position.y < companion.fruit.position.y else companion.fruit.position
	var spawned_fruit : Fruit = target_fruit.instantiate()
	spawned_fruit.position = spawn_position
	spawned_fruit.linear_velocity = (fruit.linear_velocity + companion.fruit.linear_velocity)
	
	fruit.linear_velocity = Vector2.ZERO
	fruit.angular_velocity = 0.0
	companion.fruit.linear_velocity = Vector2.ZERO
	companion.fruit.angular_velocity = 0.0
	var maker_anim := get_tree().create_tween()
	maker_anim.set_parallel()
	#坐标动画
	maker_anim.tween_property(fruit.sprite,'position:x',fruit.to_local(spawn_position).x,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	maker_anim.tween_property(fruit.sprite,'position:y',fruit.to_local(spawn_position).y,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	maker_anim.tween_property(companion.fruit.sprite,'position:x',fruit.to_local(spawn_position).x,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	maker_anim.tween_property(companion.fruit.sprite,'position:y',fruit.to_local(spawn_position).y,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	#透明度动画
	maker_anim.tween_property(fruit.sprite,'modulate:a',0,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	maker_anim.tween_property(companion.fruit.sprite,'modulate:a',0,0.1).set_trans(Tween.TransitionType.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	await maker_anim.finished
	anim.play('break')
	
	get_tree().current_scene.add_child(spawned_fruit)
	
	var make_anim := get_tree().create_tween()
	spawned_fruit.sprite.scale = Vector2(0.2,0.2)
	
	make_anim.set_parallel()
	make_anim.tween_property(spawned_fruit.sprite,'scale:x',1.00,0.5).set_trans(Tween.TransitionType.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	make_anim.tween_property(spawned_fruit.sprite,'scale:y',1.00,0.5).set_trans(Tween.TransitionType.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	start_destruct()
	companion.start_destruct()

func can_merge_with(companion: FruitComponent) -> bool:
	if !is_instance_valid(companion):
		return false
	return companion.fruit_id == fruit_id \
		and companion.get_instance_id() != get_instance_id() \
		and !making \
		and !companion.making \
		and pending_merge_target_id == 0 \
		and companion.pending_merge_target_id == 0

func reserve_merge(companion: FruitComponent) -> void:
	pending_merge_target_id = companion.get_instance_id()
	companion.pending_merge_target_id = get_instance_id()

func is_merge_reserved_with(companion: FruitComponent) -> bool:
	return pending_merge_target_id == companion.get_instance_id() \
		and companion.pending_merge_target_id == get_instance_id()

func disable_for_merge(component: FruitComponent) -> void:
	component.collision.disabled = true
	component.detect_collision_shape.disabled = true
	#component.fruit_sprite.visible = false

func start_destruct() -> void:
	collision.disabled = true
	removal_timer = get_tree().create_timer(0.2)
	removal_timer.timeout.connect(fruit_remove)

func fruit_remove() -> void:
	get_parent().queue_free()
