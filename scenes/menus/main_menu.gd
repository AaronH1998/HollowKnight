extends CanvasLayer

@onready var start_game_button: HBoxContainer = $VBoxContainer/VBoxContainer/StartButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_game_button.focus()


func _on_start_button_pressed():
	load_game()
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		
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
