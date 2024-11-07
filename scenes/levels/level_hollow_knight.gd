extends Level

var broken_chains: int = 0

@onready var hollow_knight = $Enemies/HollowKnight

func _on_level_one_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_hollow_knight_death(_pos, _dir, _geo):
	TransitionLayer.change_scene("res://scenes/menus/game_complete.tscn")


func _on_final_boss_chain_broke():
	broken_chains +=1
	if broken_chains == 4:
		hollow_knight.break_free()
