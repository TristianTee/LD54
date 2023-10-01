extends Node2D

var result_row := preload("res://scenes/Result.tscn")

var packing := preload("res://levels/Packing.tscn")

func _ready():
	var profit := 0
	for result in Misc.results:
		var new_row = result_row.instantiate()
		new_row.shape = str(result[0]).to_camel_case()
		new_row.health = str(snapped(result[1], 0.01)) + "%"
		new_row.money = "$" + str(int(result[2]))
		profit += result[2]
		$Control/Panel/VBoxContainer.add_child(new_row)
	Money.amount = profit
	$Control/Panel/Profit.text = "$" + str(int(profit))

func _on_next_pressed():
	$Transition.transition(packing)
