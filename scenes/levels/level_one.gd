extends Level

@onready var behind_door_1_obstruction: Sprite2D = $OcclusionLayer/ParallaxObstruction/ParallaxLayer/BehindDoor1


func _on_breakable_door_broken():
	behind_door_1_obstruction.hide()


func _on_cave_camera_lock_body_entered(_body):
	var tween = create_tween()
	tween.tween_property(light, "energy", 3.0, 2.0)


func _on_cave_camera_lock_body_exited(_body):
	var tween = create_tween()
	tween.tween_property(light, "energy", 1.5, 2.0)


func _on_hollow_knight_level_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/level_hollow_knight.tscn")
