extends HBoxContainer

signal pressed

@onready var focus_icon_left: AnimatedSprite2D = $FocusIconLeft/AnimatedSprite2D
@onready var focus_icon_right: AnimatedSprite2D = $FocusIconRight/AnimatedSprite2D
@onready var button: Button = $Button
@onready var focus_change_audio: AudioStreamPlayer = $Audio/FocusChange
@onready var confirm_audio: AudioStreamPlayer = $Audio/Confirm
@onready var audio_timer: Timer = $Timers/AudioTimer

@export var text: String

var original_audio_volume: float


func disable():
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.focus_mode = Control.FOCUS_NONE


func enable():
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.focus_mode = Control.FOCUS_ALL


func quiet_focus():
	focus_change_audio.volume_db = -100
	audio_timer.start()
	focus()


func focus():
	focus_change_audio.play()
	focus_icon_left.visible = true
	focus_icon_right.visible = true
	focus_icon_left.play("pointer_up")
	focus_icon_right.play("pointer_up")
	button.grab_focus()


func _ready():
	focus_icon_left.visible = false
	focus_icon_right.visible = false
	button.text = text
	original_audio_volume = focus_change_audio.volume_db


func _on_button_pressed():
	confirm_audio.play()
	pressed.emit()


func _on_button_focus_entered():
	focus()


func _on_button_focus_exited():
	focus_icon_left.play("pointer_down")
	focus_icon_right.play("pointer_down")
	focus_icon_left.visible = false
	focus_icon_right.visible = false


func _on_button_mouse_entered():
	if !button.has_focus() and !button.disabled:
		button.focus_entered.emit()


func _on_audio_timer_timeout():
	focus_change_audio.volume_db = original_audio_volume
