extends Control

signal back

@onready var master_slider = $VBoxContainer/VBoxContainer/VBoxContainer2/MasterSlider
@onready var back_button = $VBoxContainer/VBoxContainer2/BackButton

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		back.emit()
		queue_free()

func _ready():
	master_slider.quiet_focus()

func _on_back_button_pressed():
	hide()
	back.emit()


func _on_back_button_confirm_audio_finished():
	queue_free()


func _on_reset_button_pressed():
	Settings.default_volume_settings()
