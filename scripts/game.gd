extends Node2D

@onready var cooldown : Timer = $spawn_colddown
@onready var spawn_line : Node2D = $spawn_line
@export var fruits_list : Array[PackedScene]
@onready var cover_screen : CoverScreen = $cover_screen
var current_fruit : Fruit
var dragging : bool = false
var touch_x : float = 0.0
var start_time : int
var end : bool = false

func _ready() -> void:
	start_time = Time.get_ticks_msec()
	GameManager.start_time = start_time
	cooldown.start()
	$fail_judge.game_over.connect(fail)
	
func _physics_process(delta: float) -> void:
	if current_fruit:
		if !current_fruit.released:
			current_fruit.freeze = true
			current_fruit.linear_velocity = Vector2.ZERO
			current_fruit.angular_velocity = 0.0
			current_fruit.global_position = Vector2(touch_x, spawn_line.global_position.y)

func _input(event: InputEvent) -> void:
	if end:
		return
	if !current_fruit:
		return

	if event is InputEventScreenTouch:
		if event.is_pressed() and !current_fruit.released:
			dragging = true
			var touch_position : Vector2 = get_global_from_screen(event.position)
			touch_x = touch_position.x
		elif dragging and !event.is_pressed():
			dragging = false
			current_fruit.released = true
			current_fruit.freeze = false
			cooldown.start()
	
	if dragging and event is InputEventScreenDrag:
		var drag_position : Vector2 = get_global_from_screen(event.position)
		touch_x = drag_position.x
	
func _on_spawn_colddown_timeout() -> void:
	spawn_fruit()
	pass # Replace with function body.

func spawn_fruit() -> void:
	var fruit : PackedScene = fruits_list.pick_random()
	var spawned_fruit : Fruit = fruit.instantiate()
	get_tree().current_scene.add_child(spawned_fruit)
	spawned_fruit.global_position = spawn_line.global_position
	spawned_fruit.released = false
	spawned_fruit.freeze = true
	current_fruit = spawned_fruit
	touch_x = spawn_line.global_position.x

func fail() -> void:
	if !end:
		cover_screen.show_screen(false)
		end = true

func win() -> void:
	if !end:
		cover_screen.show_screen(true)
		end = true
	
func get_global_from_screen(screen_pos: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * screen_pos
