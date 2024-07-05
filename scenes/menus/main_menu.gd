extends CanvasLayer

var start_menu_scene: PackedScene = preload("res://scenes/UI/start_game_menu.tscn")
var start_menu

var default_menu_scene: PackedScene = preload("res://scenes/UI/default_menu.tscn")
var default_menu

var quit_menu_scene: PackedScene = preload("res://scenes/menus/quit_menu.tscn")
var quit_menu

var audio_menu_scene: PackedScene = preload("res://scenes/menus/audio_settings_menu.tscn")
var audio_menu


func _show_default_menu():
	default_menu = default_menu_scene.instantiate()
	add_child(default_menu)
	default_menu.connect("start", _on_start_button_pressed)
	default_menu.connect("quit", _on_quit_button_pressed)
	default_menu.connect("audio", _on_audio_button_pressed)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Globals.reset()
	
	_show_default_menu()


func _on_start_button_pressed():
	start_menu = start_menu_scene.instantiate()
	add_child(start_menu)
	start_menu.connect("back", _show_default_menu)


func _on_quit_button_pressed():
	quit_menu = quit_menu_scene.instantiate()
	add_child(quit_menu)
	quit_menu.connect("no_quit", _on_no_quit_button_pressed)


func _on_no_quit_button_pressed():
	_show_default_menu()
	

func _on_audio_button_pressed():
	audio_menu = audio_menu_scene.instantiate()
	add_child(audio_menu)
	audio_menu.connect("back", _show_default_menu)
