extends CanvasLayer

@onready var resume_button: HBoxContainer = $VBoxContainer/VBoxContainer/ResumeButton
var paused: bool = false

func _input(_event):
	if Input.is_action_just_pressed("menu"):
		get_tree().paused = !paused
		paused = !paused
		
		if paused:
			_pause()
		else:
			hide()

func _ready():
	hide()
	resume_button.focus()
	Globals.connect("paused", _pause)


func _pause():
	show()
	resume_button.focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_button_pressed():
	hide()
	get_tree().paused = false
