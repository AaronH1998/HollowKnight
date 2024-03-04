extends CanvasLayer

var can_continue: bool = false

func _input(event):
	if can_continue and (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
		TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")

func allow_continue():
	can_continue = true
