extends Button
class_name FocusMenuButton

signal confirm_audio_finished

@onready var focus_icon_left: AnimatedSprite2D = $TopLeftMargin/Control/FocusIconLeft
@onready var focus_icon_right: AnimatedSprite2D = $TopRightMargin/Control/FocusIconRight
@onready var focus_change_audio: AudioStreamPlayer = $Audio/FocusChange
@onready var confirm_audio: AudioStreamPlayer = $Audio/Confirm
@onready var audio_timer: Timer = $Timers/AudioTimer

var focus_original_volume: float


func _ready():
	focus_icon_left.visible = false
	focus_icon_right.visible = false
	focus_original_volume = focus_change_audio.volume_db


func enable():
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL


func disable():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE


func quiet_focus():
	focus_change_audio.volume_db = -100
	audio_timer.start()
	focus()


func focus():
	focus_change_audio.play()
	focus_icon_left.visible = true
	focus_icon_right.visible = true
	focus_icon_left.play("pointer up")
	focus_icon_right.play("pointer up")
	grab_focus()


func _on_focus_entered():
	focus()


func _on_focus_exited():
	focus_icon_left.play("pointer down")
	focus_icon_right.play("pointer down")
	focus_icon_left.visible = false
	focus_icon_right.visible = false


func _on_mouse_entered():
	if !has_focus() and !disabled:
		focus_entered.emit()


func _on_audio_timer_timeout():
	focus_change_audio.volume_db = focus_original_volume


func _on_confirm_finished():
	confirm_audio_finished.emit()


func _on_pressed():
	confirm_audio.play()
