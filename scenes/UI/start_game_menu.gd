extends Control

signal back

func _on_back_button_pressed():
	hide()
	back.emit()


func _on_back_button_confirm_audio_finished():
	queue_free()
