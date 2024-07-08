extends Control

signal quit
signal resume
signal audio

@onready var resume_button: Button = $VBoxContainer/VBoxContainer/ResumeButton


func _ready():
	resume_button.quiet_focus()


func _on_main_menu_button_pressed():
	hide()
	quit.emit()


func _on_main_menu_button_confirm_audio_finished():
	queue_free()


func _on_resume_button_pressed():
	hide()
	resume.emit()


func _on_audio_button_pressed():
	hide()
	audio.emit()


func _on_audio_button_confirm_audio_finished():
	queue_free()


func _on_resume_button_confirm_audio_finished():
	queue_free()
