extends Node2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var change_timer : Timer = $Timer

func change_scene(scene : String) -> void:
	anim.play('start')
	change_timer.start()
	await change_timer.timeout
	get_tree().change_scene_to_file(scene)
	await get_tree().scene_changed
	anim.play('end')
