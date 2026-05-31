extends Node2D
var fail_area_list : Array[FailZone]
signal game_over


func _ready() -> void:
	var children : Array = get_children(false)
	for child in children:
		if child is FailZone:
			fail_area_list.append(child)


func _on_timer_timeout() -> void:
	if is_failed():
		game_over.emit()

func is_failed() -> bool:
	for fail_zone in fail_area_list:
		if fail_zone.is_empty():
			return false
	return true
