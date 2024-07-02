extends CanvasLayer

var start_menu_scene: PackedScene = preload("res://scenes/UI/start_game_menu.tscn")
var start_menu

var default_menu_scene: PackedScene = preload("res://scenes/UI/default_menu.tscn")
var default_menu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.reset()
	
	default_menu = default_menu_scene.instantiate()
	add_child(default_menu)
	default_menu.connect("start", _on_start_button_pressed)


func _on_start_button_pressed():
	start_menu = start_menu_scene.instantiate()
	add_child(start_menu)
	start_menu.connect("back", _on_back_button_pressed)


func _on_back_button_pressed():
	default_menu = default_menu_scene.instantiate()
	add_child(default_menu)
	default_menu.connect("start", _on_start_button_pressed)
