extends Node2D


func _on_texture_button_pressed() -> void:
	var tween := get_tree().create_tween()
	var current_scale = $TextureButton.scale
	$TextureButton.scale = current_scale * 0.2
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($TextureButton,'scale',current_scale * 1.5,0.3)
	
	SceneChanger.change_scene('res://scenes/game.tscn')
	pass # Replace with function body.


func _on_gyro_switch_toggled(toggled_on: bool) -> void:
	GameManager.gyro_gravity_enabled = toggled_on
	pass # Replace with function body.
