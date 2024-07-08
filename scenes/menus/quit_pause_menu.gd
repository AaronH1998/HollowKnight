extends Control

signal no_quit

@onready var deny_button: Button = $VBoxContainer/DenyButton


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		no_quit.emit()
		queue_free()


func _ready():
	deny_button.quiet_focus()

func _on_confirm_button_pressed():
	if(!Persistence.save_file_path):
		print("no save active, not saving")
	else:
		print("Saving to file: " + Persistence.save_file_path)
		Persistence.save_game()
	
	TransitionLayer.change_scene("res://scenes/menus/main_menu.tscn")


func _on_deny_button_pressed():
	hide()
	no_quit.emit()


func _on_deny_button_confirm_audio_finished():
	queue_free()
