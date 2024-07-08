extends CanvasLayer

var paused: bool = false

var default_pause_menu_scene: PackedScene = preload("res://scenes/menus/default_pause_menu.tscn")
var default_pause_menu: Control

var quit_pause_menu_scene: PackedScene = preload("res://scenes/menus/quit_pause_menu.tscn")
var quit_pause_menu: Control

var audio_menu_scene: PackedScene = preload("res://scenes/menus/audio_settings_menu.tscn")
var audio_menu

func _input(_event):
	if Input.is_action_just_pressed("ui_menu"):
		if !paused:
			_pause()
		else:
			if default_pause_menu != null: 
				default_pause_menu.queue_free()
			if quit_pause_menu != null:
				quit_pause_menu.queue_free()
			_unpause()


func _show_default_menu():
	default_pause_menu = default_pause_menu_scene.instantiate()
	add_child(default_pause_menu)
	default_pause_menu.connect("quit", _on_quit_button_pressed)
	default_pause_menu.connect("resume", _on_resume_button_pressed)
	default_pause_menu.connect("audio", _on_audio_button_pressed)


func _ready():
	hide()


func _pause():
	paused = true
	get_tree().paused = true
	show()
	_show_default_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unpause():
	paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false


func _on_resume_button_pressed():
	_unpause()


func _on_quit_button_pressed():
	quit_pause_menu = quit_pause_menu_scene.instantiate()
	add_child(quit_pause_menu)
	quit_pause_menu.connect("no_quit", _show_default_menu)


func _on_audio_button_pressed():
	audio_menu = audio_menu_scene.instantiate()
	add_child(audio_menu)
	audio_menu.connect("back", _show_default_menu)
