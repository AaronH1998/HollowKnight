extends HBoxContainer

@export var save_file: String
@export var save_name: String

@onready var load_button: Button = $LoadGameButton
@onready var geo_label: Label = $LoadGameButton/HBoxContainer/GeoNumber


func _ready():
	load_button.text = save_name


func load_game(filename):
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	var read_stream = FileAccess.open(filename, FileAccess.READ)
	while read_stream.get_position() < read_stream.get_length():
		var json_string = read_stream.get_line()
		
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data = json.get_data()

		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			Globals.set(i, node_data[i])


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
		load_game(save_file)
	
	Globals.save_file = save_file
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")
