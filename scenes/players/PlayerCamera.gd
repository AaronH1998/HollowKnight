extends Camera2D

func _process(_delta):
	if Globals.near_floor or Globals.near_ceiling:
		global_position = global_position.lerp(Vector2(global_position.x, Globals.camera_height), 0.002)
	else:
		global_position = global_position.lerp(Vector2(global_position.x, Globals.player_pos.y), 0.002)
	
	if $"../PlayerPhysics/CameraPosition" != null:
		global_position.x = $"../PlayerPhysics/CameraPosition".global_position.x
