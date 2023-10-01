extends Node2D

var shapes: Dictionary =  {
	"bed": {
		"holdable": preload("res://scenes/bed/Holdable.tscn"),
		"physical": preload("res://scenes/bed/Physical.tscn"),
		"size": 3,
		"weight": 7,
		"fragility": 2
	},
	"bookshelf": {
		"holdable": preload("res://scenes/bookshelf/Holdable.tscn"),
		"physical": preload("res://scenes/bookshelf/Physical.tscn"),
		"size": 6,
		"weight": 8,
		"fragility": 4
	},
	"car": {
		"holdable": preload("res://scenes/car/Holdable.tscn"),
		"physical": preload("res://scenes/car/Physical.tscn"),
		"size": 24,
		"weight": 10,
		"fragility": 6
	},
	"chair": {
		"holdable": preload("res://scenes/chair/Holdable.tscn"),
		"physical": preload("res://scenes/chair/Physical.tscn"),
		"size": 2,
		"weight": 2,
		"fragility": 2
	},
	"coffee_table": {
		"holdable": preload("res://scenes/coffee_table/Holdable.tscn"),
		"physical": preload("res://scenes/coffee_table/Physical.tscn"),
		"size": 2,
		"weight": 3,
		"fragility": 1
	},
	"lamp": {
		"holdable": preload("res://scenes/lamp/Holdable.tscn"),
		"physical": preload("res://scenes/lamp/Physical.tscn"),
		"size": 3,
		"weight": 2,
		"fragility": 4
	},
	"table": {
		"holdable": preload("res://scenes/table/Holdable.tscn"),
		"physical": preload("res://scenes/table/Physical.tscn"),
		"size": 8,
		"weight": 5,
		"fragility": 3
	},
}

@export var shape: String 

var held: bool
var health: float
var weight: int
var fragility: int
var object
var overlaps: Array = []
var required_size: int
var pressable = false
var waited = true
var mousable = false
var ignore = true
var last_known_velocity
var running = false

func _ready():
	print(shape)
	object = shapes[shape]
	required_size = object.size
	weight = object.weight
	fragility = object.fragility
	health = float(weight) / fragility
	add_child(object.holdable.instantiate(), false, INTERNAL_MODE_DISABLED)
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
	if ignore:
		return
	var body = object.physical.instantiate()
	add_child(body, false, INTERNAL_MODE_DISABLED)
	body.mass = weight
	get_node("Area2D").queue_free()
	running = true

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
		if held && waited:
			if pressable:
				return put_down()
			else:
				if overlaps.size() == 0:
					put_down()
					ignore = true
					return 
		if mousable && !Misc.holding && waited:
			pick_up()

func pick_up():
	ignore = true
	Misc.holding = true
	held = true
	waited = false
	for square in overlaps:
		square.set_full(false)
	get_node("Area2D/Timer").start()

func put_down():
	ignore = false
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
