extends Node2D

var packing_scene := preload("res://levels/Packing.tscn")

func _on_button_3_pressed():
	$Transition.transition(packing_scene)
