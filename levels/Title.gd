extends Node2D

var packing_scene := preload("res://levels/Packing.tscn")
var music := preload("res://assets/audio/title_music.wav")

func _ready():
	Music.stream = music
	Music.playing = true

func _on_button_3_pressed():
	$Transition.transition(packing_scene)
