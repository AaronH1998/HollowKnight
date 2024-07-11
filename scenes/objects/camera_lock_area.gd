extends Area2D

@export var horizontal_lock_marker: Marker2D
@export var vertical_lock_marker: Marker2D

func _on_body_entered(_body):
	if(horizontal_lock_marker != null):
		Globals.horizontal_locks.append(horizontal_lock_marker.global_position.x)
	if(vertical_lock_marker != null):
		Globals.vertical_locks.append(vertical_lock_marker.global_position.y)


func _on_body_exited(_body):
	if(horizontal_lock_marker != null):
		Globals.horizontal_locks.erase(horizontal_lock_marker.global_position.x)
	if(vertical_lock_marker != null):
		Globals.vertical_locks.erase(vertical_lock_marker.global_position.y)
