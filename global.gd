extends Node

func spawn_item(pos):
	var ItemScene = load("res://item.tscn")
	var item = ItemScene.instantiate()
	item.global_position = pos
	call_deferred("add_child", item)
