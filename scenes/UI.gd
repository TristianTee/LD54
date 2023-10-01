extends CanvasLayer

func _ready():
	Money.connect("amount_changed", update_money)
	update_money()

func update_money():
	$Coins/Label.text = str(Money.amount)
	$AudioStreamPlayer.play()
