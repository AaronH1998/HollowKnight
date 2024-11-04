extends Level


func _on_level_one_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_hollow_knight_death(_pos, _dir, _geo):
	TransitionLayer.change_scene("res://scenes/menus/game_complete.tscn")
