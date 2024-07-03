extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/VBoxContainer/ResumeButton

var paused: bool = false


func _input(_event):
	if Input.is_action_just_pressed("menu"):
		paused = !paused
		if paused:
			_pause()
		else:
			_unpause()


func _ready():
	hide()


func _pause():
	get_tree().paused = true
	show()
	resume_button.focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unpause():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false


func _on_resume_button_pressed():
	_unpause()
	

func _on_main_menu_button_pressed():
	if(!Persistence.save_file_path):
		print("no save active, not saving")
	else:
		print("Saving to file: " + Persistence.save_file_path)
		Persistence.save_game()
	
	TransitionLayer.change_scene("res://scenes/menus/main_menu.tscn")
