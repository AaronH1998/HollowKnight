extends StaticBody2D


func _on_camera_lock_area_body_entered(body):
	Globals.near_ceiling = true


func _on_camera_lock_area_body_exited(body):
	Globals.near_ceiling = false
