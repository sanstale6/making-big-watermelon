extends CanvasLayer
class_name CoverScreen
@onready var anim = $AnimationPlayer

func show_screen(win : bool) -> void:
	var passed_time = (Time.get_ticks_msec() - GameManager.start_time)/1000
	var subtitle = '耗时: ' + str(passed_time) + 's'
	$display/fail_screen/title/time.text = subtitle
	$display/win_screen/title/time.text = subtitle
	
	if win:
		$display/win_screen.visible = true
	else:
		$display/fail_screen.visible = true
	anim.play('show')

func _on_texture_button_pressed() -> void:
	SceneChanger.change_scene('res://scenes/game.tscn')
	pass # Replace with function body.
