extends CanvasLayer

@onready var money = $coins/label

func _ready():
	Money.connect("amount_changed", update_money)
	update_money()

func update_money():
	money.text = str(Money.amount)
