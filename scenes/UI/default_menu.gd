extends Control

signal start

@onready var start_game_button: HBoxContainer = $VBoxContainer/VBoxContainer/StartButton


func _ready():
	start_game_button.quiet_focus()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	hide()
	start.emit()


func _on_start_button_confirm_audio_finished():
	queue_free()
