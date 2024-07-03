extends CanvasLayer

var paused: bool = false

var default_pause_menu_scene: PackedScene = preload("res://scenes/menus/default_pause_menu.tscn")
var default_pause_menu: Control

var quit_pause_menu_scene: PackedScene = preload("res://scenes/menus/quit_pause_menu.tscn")
var quit_pause_menu: Control


func _input(_event):
	if Input.is_action_just_pressed("menu"):
		paused = !paused
		if paused:
			_pause()
		else:
			_unpause()


func show_default_menu():
	default_pause_menu = default_pause_menu_scene.instantiate()
	add_child(default_pause_menu)
	default_pause_menu.connect("quit", _on_quit_button_pressed)
	default_pause_menu.connect("resume", _on_resume_button_pressed)	


func _ready():
	hide()


func _pause():
	get_tree().paused = true
	show()
	show_default_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unpause():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if quit_pause_menu:
		quit_pause_menu.queue_free()
	get_tree().paused = false


func _on_resume_button_pressed():
	_unpause()


func _on_quit_button_pressed():
	quit_pause_menu = quit_pause_menu_scene.instantiate()
	add_child(quit_pause_menu)
	quit_pause_menu.connect("no_quit", _on_no_quit_button_pressed)
	

func _on_no_quit_button_pressed():
	show_default_menu()

