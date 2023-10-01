extends CanvasLayer

func _ready():
	var ready_tween := create_tween()
	ready_tween.tween_property($ColorRect, "color", Color(0.192, 0, 0.192, 0), 2)
	$ColorRect.mouse_filter = $ColorRect.MOUSE_FILTER_IGNORE

func transition(node: PackedScene):
	$ColorRect.mouse_filter = $ColorRect.MOUSE_FILTER_STOP
	var transition_tween := create_tween()
	transition_tween.tween_property($ColorRect, "color", Color(0.192, 0, 0.192, 1), 2)
	get_tree().change_scene_to_packed(node)
