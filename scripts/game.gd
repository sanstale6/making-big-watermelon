extends Node2D

@onready var colddown : Timer = $spawn_colddown
@onready var spawn_line : Node2D = $spawn_line
@export var fruits_list : Array[PackedScene]
var current_fruit : Fruit
var dragging : bool = false

func _ready() -> void:
	colddown.start()
	
func _physics_process(delta: float) -> void:
	if current_fruit:
		if !current_fruit.released:
			current_fruit.position.y = spawn_line.position.y

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed() and !current_fruit.released:
		dragging = true
	
	if dragging and event is InputEventScreenDrag:
		var touch_position : Vector2 = get_global_from_screen(event.position)
		
		#问题位置
		current_fruit.position.x = touch_position.x
	
	if dragging and event is InputEventScreenTouch and !event.is_pressed():
		dragging = false
		current_fruit.released = true
		colddown.start()
	
func _on_spawn_colddown_timeout() -> void:
	spawn_fruit()
	pass # Replace with function body.

func spawn_fruit() -> void:
	var fruit : PackedScene = fruits_list.pick_random()
	var spawned_fruit : Fruit = fruit.instantiate()
	get_tree().current_scene.add_child(spawned_fruit)
	spawned_fruit.position = spawn_line.position
	spawned_fruit.released = false
	current_fruit = spawned_fruit
	
	
func get_global_from_screen(screen_pos: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * screen_pos
