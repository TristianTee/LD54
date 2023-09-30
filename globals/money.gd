extends Node

signal amount_changed

var amount: int = 0 : 
	set(value):
		if(value != 0):
			amount += value
			amount_changed.emit()
	get:
		return amount

