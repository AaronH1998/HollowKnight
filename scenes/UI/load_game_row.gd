extends HBoxContainer

signal clear_save(filepath)

@export var save_file: String
@export var save_name: String

@onready var geo_label: Label = $LoadGameFocus/LoadGameButton/MainDisplay/GeoDisplay/HBoxContainer/GeoNumber
@onready var main_display: Control = $LoadGameFocus/LoadGameButton/MainDisplay
@onready var confirmation_display = $LoadGameFocus/LoadGameButton/ConfirmationDisplay
@onready var game_label = $LoadGameFocus/LoadGameButton/MainDisplay/Label
@onready var focus_icon_left = $LoadGameFocus/FocusIconLeft/AnimatedSprite2D
@onready var focus_icon_right = $LoadGameFocus/FocusIconRight/AnimatedSprite2D
@onready var load_game_button = $LoadGameFocus/LoadGameButton

var game_data: Array


func _ready():
	main_display.visible = true
	confirmation_display.visible = false
	game_label.text = save_name
	focus_icon_left.visible = false
	focus_icon_right.visible = false
	
	if not FileAccess.file_exists(save_file):
		print("save file: " + save_file + " doesn't exist, not loading game info")
		geo_label.text = "0"
	else:
		print("loading game info for save: " + save_file)
		game_data = get_game_data(save_file)
		var geo_count = get_geo_count(game_data)
		geo_label.text = str(geo_count)


func get_geo_count(data: Array) -> int:
	for item in data:
		if(item.has("geo")):
			return item["geo"]
	return 0


func get_game_data(filename: String) -> Array:
	var parsed_data = []
	
	var read_stream = FileAccess.open(filename, FileAccess.READ)
	while read_stream.get_position() < read_stream.get_length():
		var json_string = read_stream.get_line()
		
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		parsed_data.append(json.get_data())
		
	read_stream.close()
	return parsed_data


func load_game():
	for item in game_data:
		for i in item.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			Globals.set(i, item[i])


func save_game(filename):
	var write_stream = FileAccess.open(filename, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		write_stream.store_line(json_string)


func _on_load_game_button_pressed():
	if not FileAccess.file_exists(save_file):
		print("file doesn't exist, creating fresh save")
		save_game(save_file)
	else:
		print("loading save from: " + save_file)
		load_game()
	
	Globals.save_file = save_file
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_clear_save_button_pressed():
	main_display.visible = false
	confirmation_display.visible = true


func _on_confirm_button_pressed():
	DirAccess.remove_absolute(save_file)
	game_data = []
	geo_label.text = "0"
	main_display.visible = true
	confirmation_display.visible = false


func _on_deny_button_pressed():
	main_display.visible = true
	confirmation_display.visible = false


func _on_load_game_button_focus_entered():
	focus_icon_left.visible = true
	focus_icon_right.visible = true
	focus_icon_left.play("pointer_up")
	focus_icon_right.play("pointer_up")
	load_game_button.grab_focus()


func _on_load_game_button_focus_exited():
	focus_icon_left.play("pointer_down")
	focus_icon_right.play("pointer_down")
	focus_icon_left.visible = false
	focus_icon_right.visible = false


func _on_load_game_button_mouse_entered():
	load_game_button.focus_entered.emit()
	load_game_button.grab_focus()
