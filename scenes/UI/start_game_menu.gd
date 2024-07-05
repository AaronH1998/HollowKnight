extends Control

signal back

@onready var back_button: FocusMenuButton = $VBoxContainer/Content/BackButton

func _ready():
	back_button.quiet_focus()


func _on_back_button_pressed():
	hide()
	back.emit()


func _on_back_button_confirm_audio_finished():
	queue_free()
