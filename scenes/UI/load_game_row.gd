extends HBoxContainer

@export var save_file: String
@export var save_name: String

@onready var geo_label: Label = $LoadGameFocus/LoadGameButton/MainDisplay/GeoDisplay/HBoxContainer/GeoNumber
@onready var main_display: Control = $LoadGameFocus/LoadGameButton/MainDisplay
@onready var confirmation_display: HBoxContainer = $LoadGameFocus/LoadGameButton/ConfirmationDisplay
@onready var game_label: Label = $LoadGameFocus/LoadGameButton/GameLabel
@onready var focus_icon_left: AnimatedSprite2D = $LoadGameFocus/FocusIconLeft/AnimatedSprite2D
@onready var focus_icon_right: AnimatedSprite2D = $LoadGameFocus/FocusIconRight/AnimatedSprite2D
@onready var load_game_button: Button = $LoadGameFocus/LoadGameButton
@onready var focus_change_audio: AudioStreamPlayer = $Audio/FocusChange
@onready var confirm_audio: AudioStreamPlayer = $Audio/Confirm
@onready var new_game_display: MarginContainer = $LoadGameFocus/LoadGameButton/NewGameDisplay
@onready var clear_save_button: HBoxContainer = $ClearSaveButton
@onready var deny_button: HBoxContainer = $LoadGameFocus/LoadGameButton/ConfirmationDisplay/ConfirmationButtons/DenyButton

var world_stats: WorldStats


func _ready():
	custom_minimum_size = size
	main_display.visible = true
	confirmation_display.visible = false
	new_game_display.visible = false
	game_label.visible = true
	game_label.text = save_name
	focus_icon_left.visible = false
	focus_icon_right.visible = false
	
	if not FileAccess.file_exists(save_file):
		print("save file: " + save_file + " doesn't exist, not loading game info")
		new_game_display.visible = true
		main_display.visible = false
		clear_save_button.visible = false
	else:
		print("loading game info for save: " + save_file)
		var game_data = Persistence.get_game_data(save_file)
		geo_label.text = str(game_data["geo"])


func _on_load_game_button_pressed():
	Persistence.save_file_path = save_file
	if not FileAccess.file_exists(save_file):
		print("file doesn't exist, creating fresh save")
		Persistence.new_game()
	else:
		print("loading save from: " + save_file)
		Persistence.load_game()
	
	confirm_audio.play()
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_clear_save_button_pressed():
	main_display.visible = false
	game_label.visible = false
	clear_save_button.visible = false
	confirmation_display.visible = true
	deny_button.focus()


func _on_confirm_button_pressed():
	Persistence.delete_save(save_file)
	new_game_display.visible = true
	game_label.visible = true
	confirmation_display.visible = false
	clear_save_button.visible = false


func _on_deny_button_pressed():
	main_display.visible = true
	game_label.visible = true
	clear_save_button.visible = true
	confirmation_display.visible = false


func focus():
	focus_icon_left.visible = true
	focus_icon_right.visible = true
	focus_icon_left.play("pointer_up")
	focus_icon_right.play("pointer_up")
	load_game_button.grab_focus()


func _on_load_game_button_focus_entered():
	focus_change_audio.play()
	focus()


func _on_load_game_button_focus_exited():
	focus_icon_left.play("pointer_down")
	focus_icon_right.play("pointer_down")
	focus_icon_left.visible = false
	focus_icon_right.visible = false


func _on_load_game_button_mouse_entered():
	if !load_game_button.has_focus():
		load_game_button.focus_entered.emit()
