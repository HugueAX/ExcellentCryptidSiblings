extends Area2D

var end_scene = "res://end.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file(end_scene)
