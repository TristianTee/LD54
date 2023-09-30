extends Node2D

@export var acceloration := 10
@export var maxSpeed := 100

var can_start = true
var truck_on = false

func _ready():
	pass

func _input(event):
	if event.is_action("ui_accept") && can_start:
		can_start = false
		start()

func start():
	for packable in $Packables.get_children():
		packable.make_real()
	$Overlay.queue_free()
	$Timer.start()

func _on_timer_timeout():
	truck_on = true
	var truck_tween = create_tween()
	$Truck/Camera2D.enabled = true
	truck_tween.set_ease(Tween.EASE_IN).tween_property($Truck, "position", Vector2(5000, $Truck.position.y), 10)
	truck_tween.set_ease(0).tween_property($Truck, "position", Vector2(5010, $Truck.position.y - 50), 0.1 )
	truck_tween.tween_property($Truck, "position", Vector2(5020, $Truck.position.y + 50), 0.1 )
	truck_tween.set_ease(Tween.EASE_IN).tween_property($Truck, "position", Vector2(10000, $Truck.position.y), 10)
