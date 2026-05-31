extends Area2D
class_name FailZone

var body_id_list :  Array[int] = []


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('fruit') and body.released:
		body_id_list.append(body.get_instance_id())


func _on_body_exited(body: Node2D) -> void:
	var instance_id = body.get_instance_id()
	if body.is_in_group('fruit') and body_id_list.has(instance_id) and body.released:
		body_id_list.erase(instance_id)

func is_empty() -> bool :
	return body_id_list.is_empty()
