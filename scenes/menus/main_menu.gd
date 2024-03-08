extends CanvasLayer

@onready var start_game_focus_icon_left: AnimatedSprite2D = $VBoxContainer/VBoxContainer/StartGame/FocusIconLeft/AnimatedSprite2D
@onready var start_game_focus_icon_right: AnimatedSprite2D = $VBoxContainer/VBoxContainer/StartGame/FocusIconRight/AnimatedSprite2D
@onready var start_game_button: Button = $VBoxContainer/VBoxContainer/StartGame/StartGameButton
@onready var quit_game_focus_icon_left: AnimatedSprite2D = $VBoxContainer/VBoxContainer/QuitGame/FocusIconLeft/AnimatedSprite2D
@onready var quit_game_focus_icon_right: AnimatedSprite2D = $VBoxContainer/VBoxContainer/QuitGame/FocusIconRight/AnimatedSprite2D
@onready var quit_game_button: Button = $VBoxContainer/VBoxContainer/QuitGame/QuitGameButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_game_button.grab_focus()


func _on_start_game_button_pressed():
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_quit_game_button_pressed():
	get_tree().quit()


func _on_start_game_button_focus_entered():
	start_game_focus_icon_left.visible = true
	start_game_focus_icon_right.visible = true
	start_game_focus_icon_left.play("pointer_up")
	start_game_focus_icon_right.play("pointer_up")
	quit_game_button.focus_exited.emit()

func _on_start_game_button_mouse_entered():
	start_game_button.focus_entered.emit()


func _on_start_game_button_focus_exited():
	start_game_focus_icon_left.play("pointer_down")
	start_game_focus_icon_right.play("pointer_down")
	start_game_focus_icon_left.visible = false
	start_game_focus_icon_right.visible = false
	
func _on_quit_game_button_focus_entered():
	quit_game_focus_icon_left.visible = true
	quit_game_focus_icon_right.visible = true
	quit_game_focus_icon_left.play("pointer_up")
	quit_game_focus_icon_right.play("pointer_up")
	start_game_button.focus_exited.emit()

func _on_quit_game_button_focus_exited():
	quit_game_focus_icon_left.play("pointer_down")
	quit_game_focus_icon_right.play("pointer_down")
	quit_game_focus_icon_left.visible = false
	quit_game_focus_icon_right.visible = false


func _on_quit_game_button_mouse_entered():
	quit_game_button.focus_entered.emit()
	
