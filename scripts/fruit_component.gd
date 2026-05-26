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
	collision.disabled = true
	detect_area.get_node('CollisionShape2D').disabled = true
	fruit.get_node('Sprite2D').visible = false
	if get_instance_id() < companion.get_instance_id():
		return
	anim.play('break')
	var spawn_position = (get_parent().position + companion.get_parent().position)*0.5
	print(spawn_position)
	var spawned_fruit = target_fruit.instantiate()
	spawned_fruit.position = spawn_position
	get_tree().current_scene.add_child(spawned_fruit)
