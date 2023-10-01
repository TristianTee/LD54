extends Button

@export var cost: int
@export var shape: String

signal buying(shape: String)

func _ready():
	text = "$" + str(cost) + "   -   " + shape

func _on_pressed():
	if !Misc.holding && Money.amount >= cost:
		Money.amount = -cost
		buying.emit(shape)
