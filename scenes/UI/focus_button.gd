extends HBoxContainer

signal pressed

@onready var focus_icon_left: AnimatedSprite2D = $FocusIconLeft/AnimatedSprite2D
@onready var focus_icon_right: AnimatedSprite2D = $FocusIconRight/AnimatedSprite2D
@onready var button: Button = $Button

@export var text: String


func focus():
	button.grab_focus()


func _ready():
	focus_icon_left.visible = false
	focus_icon_right.visible = false
	button.text = text


func _on_button_pressed():
	pressed.emit()


func _on_button_focus_entered():
	focus_icon_left.visible = true
	focus_icon_right.visible = true
	focus_icon_left.play("pointer_up")
	focus_icon_right.play("pointer_up")
	focus()


func _on_button_focus_exited():
	focus_icon_left.play("pointer_down")
	focus_icon_right.play("pointer_down")
	focus_icon_left.visible = false
	focus_icon_right.visible = false


func _on_button_mouse_entered():
	button.focus_entered.emit()
	focus()
