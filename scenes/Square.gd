extends Area2D

var normal := preload("res://assets/square1.png")
var wrong := preload("res://assets/square3.png")
var good := preload("res://assets/square2.png")

var has_contents := false

func set_full(value: bool):
	has_contents = value
	if value:
		$Sprite2D.texture = normal

func get_full():
	return has_contents

func _on_area_entered(_area):
	if has_contents:
		$Sprite2D.texture = wrong
	else:
		$Sprite2D.texture = good

func _on_area_exited(_area):
	$Sprite2D.texture = normal
