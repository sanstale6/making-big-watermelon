extends Node2D


func _on_texture_button_pressed() -> void:
	SceneChanger.change_scene('res://scenes/game.tscn')
	pass # Replace with function body.


func _on_gyro_switch_toggled(toggled_on: bool) -> void:
	GameManager.gyro_gravity_enabled = toggled_on
	pass # Replace with function body.
