extends Node2D

var packing_scene := preload("res://levels/Packing.tscn")

func _ready():
	var initSeed := hash(Time.get_datetime_string_from_datetime_dict(Time.get_datetime_dict_from_system(), false))
	Misc.rng_seed = initSeed
	Misc.connect('rng_seed_changed', update_rng_seed)
	update_rng_seed()

func update_rng_seed():
	$Control/Panel/Seed.text = str(Misc.rng_seed)

func _on_button_pressed():
	$Control/Panel/Seed.text = str(DisplayServer.clipboard_get())

func _on_button_2_pressed():
	DisplayServer.clipboard_set($Control/Panel/Seed.text)

func _on_button_3_pressed():
	print("here")
	Misc.rng_seed = $Control/Panel/Seed.text
	$Transition.transition(packing_scene)
