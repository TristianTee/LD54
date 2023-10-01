extends CanvasLayer

func _ready():
	Money.connect("amount_changed", update_money)
	update_money()

func update_money():
	$Coins/Label.text = str(Money.amount)
	$AudioStreamPlayer.play()


func _on_texture_button_pressed():
	Music.playing = !Music.playing
