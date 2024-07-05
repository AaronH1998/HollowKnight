extends Control

signal start
signal quit
signal audio

@onready var start_game_button: Button = $VBoxContainer/VBoxContainer/StartButton


func _ready():
	start_game_button.quiet_focus()


func _on_start_button_pressed():
	hide()
	start.emit()


func _on_start_button_confirm_audio_finished():
	queue_free()


func _on_exit_button_pressed():
	hide()
	quit.emit()


func _on_quit_button_confirm_audio_finished():
	queue_free()


func _on_audio_button_pressed():
	hide()
	audio.emit()


func _on_audio_button_confirm_audio_finished():
	queue_free()
