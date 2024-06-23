extends CanvasLayer


@onready var resume_focus_icon_left: AnimatedSprite2D = $VBoxContainer/VBoxContainer/ResumeMenu/FocusIconLeft/AnimatedSprite2D
@onready var resume_focus_icon_right: AnimatedSprite2D = $VBoxContainer/VBoxContainer/ResumeMenu/FocusIconRight/AnimatedSprite2D
@onready var resume_button: Button = $VBoxContainer/VBoxContainer/ResumeMenu/ResumeButton


func _ready():
	hide()


func pause():
	show()
	resume_button.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_button_focus_entered():
	resume_focus_icon_left.visible = true
	resume_focus_icon_right.visible = true
	resume_focus_icon_left.play("pointer_up")
	resume_focus_icon_right.play("pointer_up")


func _on_resume_button_focus_exited():
	resume_focus_icon_left.play("pointer_down")
	resume_focus_icon_right.play("pointer_down")
	resume_focus_icon_left.visible = false
	resume_focus_icon_right.visible = false


func _on_resume_button_mouse_entered():
	resume_button.focus_entered.emit()


func _on_resume_button_pressed():
	_unpause()


func _unpause():
	hide()
	get_tree().paused = false
