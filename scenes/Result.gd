extends HBoxContainer

@export var shape: String
@export var health: String
@export var money: String

func _ready():
	$Shape.text = shape
	$Health.text = health
	$Money.text = money
