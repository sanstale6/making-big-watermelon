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
	var target_fruit_component : FruitComponent = body.get_node('FruitComponent')
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
	anim.play('break')
	#var spawn_position = (get_parent().position + companion.get_parent().position)*0.5
	var spawn_position : Vector2 = fruit.position if fruit.position.y < companion.fruit.position.y else companion.fruit.position
	var spawned_fruit : Fruit = target_fruit.instantiate()
	spawned_fruit.position = spawn_position
	spawned_fruit.linear_velocity = (fruit.linear_velocity + companion.fruit.linear_velocity)
	
	get_tree().current_scene.add_child(spawned_fruit)
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
	component.fruit_sprite.visible = false

func start_destruct() -> void:
	collision.disabled = true
	removal_timer = get_tree().create_timer(0.2)
	removal_timer.timeout.connect(fruit_remove)

func fruit_remove() -> void:
	get_parent().queue_free()
