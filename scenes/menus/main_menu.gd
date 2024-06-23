extends CanvasLayer

@onready var start_game_button: HBoxContainer = $VBoxContainer/VBoxContainer/StartButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_game_button.focus()


func _on_start_button_pressed():
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
