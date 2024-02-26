extends StaticBody2D

func _on_camera_lock_area_body_entered(_body):
	Globals.near_floor = true
	Globals.camera_height = $CameraLockArea/CameraMinHeight.global_position.y

func _on_camera_lock_area_body_exited(_body):
	Globals.near_floor = false
