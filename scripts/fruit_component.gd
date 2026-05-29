extends Node2D
class_name FruitComponent

@export var fruit : Fruit
@export var collision : CollisionShape2D
@export var fruit_id : String
@export var detect_area : Area2D
@export_file var target_fruit
@export var anim : AnimationPlayer
var making : bool = false

func _ready() -> void:
	detect_area.body_entered.connect(collision_judge)
	target_fruit = load(target_fruit)
	


func collision_judge(body):
	if !body.is_in_group('fruit'):
		return
	var target_fruit_component = body.get_node('FruitComponent')
	if target_fruit_component.making :
		return
	if target_fruit_component.fruit_id == fruit_id and target_fruit_component.get_instance_id() != get_instance_id():
		integrate(target_fruit_component)
		
func integrate(companion : FruitComponent) -> void:
	if making:
		return
	making = true
	companion.making = true
	collision.disabled = true
	detect_area.get_node('CollisionShape2D').disabled = true
	fruit.get_node('Sprite2D').visible = false
	companion.collision.disabled = true
	companion.detect_area.get_node('CollisionShape2D').disabled = true
	companion.fruit.get_node('Sprite2D').visible = false
	anim.play('break')
	var spawn_position = (get_parent().position + companion.get_parent().position)*0.5
	print(spawn_position)
	var spawned_fruit = target_fruit.instantiate()
	spawned_fruit.position = spawn_position
	get_tree().current_scene.add_child(spawned_fruit)
	start_destruct()
	companion.start_destruct()

func start_destruct() -> void:
	collision.disabled = true
	get_tree().create_timer(0.2).timeout.connect(fruit_remove)

func fruit_remove() -> void:
	get_parent().queue_free()
