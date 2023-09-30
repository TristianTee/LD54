extends Node2D

@export var width := 8
@export var height := 10

var square := preload("res://scenes/Square.tscn")

func _ready():
	for w in width:
		for h in height:
			var unpackedSquare = square.instantiate()
			unpackedSquare.position = Vector2(w * 32, h * 32)
			add_child(unpackedSquare)
