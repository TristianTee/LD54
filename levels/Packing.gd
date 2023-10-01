extends Node2D

@export var acceloration := 10
@export var maxSpeed := 100

var can_start = true
var truck_on = false

var packable_item = preload("res://scenes/PackableItem.tscn")
var buy_button = preload("res://scenes/BuyButton.tscn")
var rewards = preload("res://levels/Rewards.tscn")

var shapes: Dictionary =  {
	"bed": {
		"holdable": preload("res://scenes/bed/Holdable.tscn"),
		"physical": preload("res://scenes/bed/Physical.tscn"),
		"size": 3,
		"weight": 7,
		"fragility": 2,
		"cost": 50,
		"value": 100
	},
	"bookshelf": {
		"holdable": preload("res://scenes/bookshelf/Holdable.tscn"),
		"physical": preload("res://scenes/bookshelf/Physical.tscn"),
		"size": 6,
		"weight": 8,
		"fragility": 3,
		"cost": 75,
		"value": 200
	},
	"car": {
		"holdable": preload("res://scenes/car/Holdable.tscn"),
		"physical": preload("res://scenes/car/Physical.tscn"),
		"size": 24,
		"weight": 10,
		"fragility": 6,
		"cost": 500,
		"value": 2000
	},
	"chair": {
		"holdable": preload("res://scenes/chair/Holdable.tscn"),
		"physical": preload("res://scenes/chair/Physical.tscn"),
		"size": 2,
		"weight": 2,
		"fragility": 3,
		"cost": 5,
		"value": 10
	},
	"coffee_table": {
		"holdable": preload("res://scenes/coffee_table/Holdable.tscn"),
		"physical": preload("res://scenes/coffee_table/Physical.tscn"),
		"size": 2,
		"weight": 3,
		"fragility": 1,
		"cost": 10,
		"value": 15,
	},
	"lamp": {
		"holdable": preload("res://scenes/lamp/Holdable.tscn"),
		"physical": preload("res://scenes/lamp/Physical.tscn"),
		"size": 3,
		"weight": 2,
		"fragility": 4,
		"cost": 20,
		"value": 50
	},
	"table": {
		"holdable": preload("res://scenes/table/Holdable.tscn"),
		"physical": preload("res://scenes/table/Physical.tscn"),
		"size": 8,
		"weight": 5,
		"fragility": 3,
		"cost": 80,
		"value": 150
	},
}

func _ready():
	for shape in shapes.keys():
		var button = buy_button.instantiate()
		button.shape = shape
		button.cost = shapes[shape].cost
		button.connect('buying', buy)
		$Panel/VBoxContainer.add_child(button)

func buy(shape):
	print(shape)
	var new_held = packable_item.instantiate()
	new_held.shape = shape
	new_held.held = true
	Misc.holding = true
	$Packables.add_child(new_held)

func _input(event):
	if event.is_action("ui_accept"):
		start()

func start():
	if can_start:
		can_start = false
		for packable in $Packables.get_children():
			packable.make_real()
		$Overlay.queue_free()
		$Timer.start()

func _on_timer_timeout():
	truck_on = true
	var truck_tween = create_tween()
	$Truck/Camera2D.enabled = true
	truck_tween.set_ease(Tween.EASE_IN).tween_property($Truck, "position", Vector2(5000, $Truck.position.y), 10)
	truck_tween.set_ease(Tween.EASE_OUT).tween_property($Truck, "position", Vector2(5010, $Truck.position.y - 50), 0.1 )
	truck_tween.set_ease(Tween.EASE_IN).tween_property($Truck, "position", Vector2(5020, $Truck.position.y + 50), 0.1 )
	truck_tween.tween_property($Truck, "position", Vector2(10000, $Truck.position.y), 10)
	truck_tween.tween_callback(finish).set_delay(2)

func finish():
	Misc.clear_results()
	for item in $Packables.get_children():
		if(item.health < 0):
			item.health = 0
		Misc.add_results([item.shape, 100 - item.health, item.value * item.health / 100])
	$Transition.transition(rewards)

func _on_button_pressed():
	start()
