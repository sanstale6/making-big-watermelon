extends Node2D
class_name FruitComponent

@export var collision : CollisionShape2D
@export var fruit_id : String
@export var detect_area : Area2D
@export var target : PackedScene
@export var anim : AnimationPlayer

func _ready() -> void:
	detect_area.body_entered.connect(collision_judge)
	


func collision_judge(body : Fruit):
	var target_fruit_component = body.get_node('FruitComponent')
	if target_fruit_component.fruit_id == fruit_id:
		integrate(target_fruit_component)
		
func integrate(companion : FruitComponent) -> void:
	collision.disabled = true
	detect_area.get_node('CollisionShape2D').disabled = true
	get_parent().get_node('Sprite2D').invisible = false
	if get_instance_id() > companion.get_instance_id():
		return
	var spawn_position = (position + companion.position)/2
	var spawned_fruit = target.instantiate()
	spawned_fruit.position = spawn_position
	get_tree().current_scene.add_child(spawned_fruit)
