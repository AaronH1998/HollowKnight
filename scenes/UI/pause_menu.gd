extends CanvasLayer

@onready var resume_button: HBoxContainer = $VBoxContainer/VBoxContainer/ResumeButton

var paused: bool = false


func _input(_event):
	if Input.is_action_just_pressed("menu"):
		paused = !paused
		if paused:
			_pause()
		else:
			_unpause()


func _ready():
	hide()


func _pause():
	get_tree().paused = true
	show()
	resume_button.focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _unpause():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false


func _on_resume_button_pressed():
	_unpause()


func _on_main_menu_button_pressed():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
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
		save_game.store_line(json_string)
			
	TransitionLayer.change_scene("res://scenes/menus/main_menu.tscn")
