extends Node2D

enum Shape {
	bed,
	bookshelf,
	car,
	chair,
	coffee_table,
	lamp,
	piano,
	table,
	vase,
}

@export var held: bool

@export var weight: int
@export var shape: Shape
@export var fragility: int

var overlaps: Array = []
var required_size: int = 2
var pressable = false
var waited = true
var mousable = false

func _ready():
	var loadable: PackedScene = load("res://scenes/" + Shape.keys()[shape] + "/Holdable.tscn")
	add_child(loadable.instantiate(), false, INTERNAL_MODE_DISABLED)
	var area: Area2D = get_node("Area2D")
	area.connect('area_entered', add_area)
	area.connect('area_exited', remove_area)
	area.connect("mouse_entered", make_mousable)
	area.connect("mouse_exited", unmake_mousable)
	area.get_node("Timer").connect("timeout", can_time)

func _process(_delta):
	if held:
		var mouse := get_global_mouse_position()
		global_position = Vector2(int(mouse.x/32)*32, int(mouse.y/32)*32) 
		pressable = can_press()

func make_real():
	var loadable: PackedScene = load("res://scenes/" + Shape.keys()[shape] + "/Physical.tscn")	
	add_child(loadable.instantiate(), false, INTERNAL_MODE_DISABLED)
	get_node("RigidBody2D").mass = float(weight)
	get_node("Area2D").queue_free()

func add_area(collision):
	if collision.has_method("get_full"):
		overlaps.append(collision)

func remove_area(uncollision):
	overlaps.erase(uncollision)

func make_mousable():
	mousable = true

func unmake_mousable():
	mousable = false
	
func _input(event):
	if event.is_action("mouse_click", true): 
		if held && waited && pressable:
			return put_down()
		if mousable && !Misc.holding && waited:
			pick_up()

func pick_up():
	Misc.holding = true
	held = true
	waited = false
	for square in overlaps:
		square.set_full(false)
	get_node("Area2D/Timer").start()

func put_down():
	Misc.holding = false
	held = false
	waited = false
	for square in overlaps:
		square.set_full(true)
	get_node("Area2D/Timer").start()

func can_time():
	waited = true

func can_press():
	if overlaps.size() == required_size:
		for square in overlaps:
			if square.get_full():
				return false
		return true
	return false
