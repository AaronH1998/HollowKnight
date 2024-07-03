extends Control

signal no_quit

func _on_confirm_button_pressed():
	get_tree().quit()


func _on_deny_button_pressed():
	hide()
	no_quit.emit()

func _on_deny_button_confirm_audio_finished():
	queue_free()
