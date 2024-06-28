extends CanvasLayer

@onready var start_game_button: HBoxContainer = $DefaultMenu/VBoxContainer/VBoxContainer/StartButton
@onready var default_menu: Control = $DefaultMenu
@onready var start_menu: Control = $StartGameMenu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	default_menu.visible = true
	start_menu.visible = false
	start_game_button.focus()


func _on_start_button_pressed():
	default_menu.visible = false
	start_menu.visible = true


func _on_quit_button_pressed():
	get_tree().quit()
	
