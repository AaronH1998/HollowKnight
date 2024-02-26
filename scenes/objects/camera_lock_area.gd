extends Area2D

@export var can_look_up: bool = true
@export var can_look_down: bool = true

func _on_body_entered(body):
	Globals.can_look_up = can_look_up
	Globals.can_look_down = can_look_up
	Globals.camera_lock_areas += 1
	Globals.camera_height = global_position.y + Globals.CAMERA_LOCK_HEIGHT

func _on_body_exited(body):
	Globals.camera_vertical_locked = false
	Globals.camera_lock_areas -= 1
