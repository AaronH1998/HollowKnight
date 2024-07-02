extends Node

signal geo_change(geo)

var save_file_path: String

var world_stats: WorldStats = WorldStats.new()


func reset():
	world_stats = WorldStats.new()


func save_game():
	var write_stream = FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_object = world_stats.to_dict()
	var json_string = JSON.stringify(json_object)
	write_stream.store_line(json_string)


func load_game():
	var game_data = get_game_data(save_file_path)
	
	for i in game_data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			continue
		world_stats.set(i, game_data[i])
	

func new_game():
	reset()
	save_game()


func delete_save(save_file):
	DirAccess.remove_absolute(save_file)


func add_geo(geo: int):
	world_stats.geo += geo
	geo_change.emit(world_stats.geo)
	

func get_game_data(file_path) -> Variant:
	var json_object: Variant
	var read_stream = FileAccess.open(file_path, FileAccess.READ)
	while read_stream.get_position() < read_stream.get_length():
		var json_string = read_stream.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
			
		var data = json.get_data()
		
		json_object = data
		
	read_stream.close()
	
	print(json_object)
	return json_object

#func load_game() -> void:
	#Globals.queue_free()
	#add_child(Globals)
		#
	#var game_data = get_game_data()
	#for item in game_data:
		#for i in item.keys():
			#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				#continue
			#Globals.set(i, item[i])
#
#
#func save_game() -> void:
	#var write_stream = FileAccess.open(save_file_path, FileAccess.WRITE)
	#var save_nodes = get_tree().get_nodes_in_group("Persist")
	#for node in save_nodes:
		## Check the node is an instanced scene so it can be instanced again during load.
		#if node.scene_file_path.is_empty():
			#print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			#continue
#
		## Check the node has a save function.
		#if !node.has_method("save"):
			#print("persistent node '%s' is missing a save() function, skipped" % node.name)
			#continue
#
		## Call the node's save function.
		#var node_data = node.call("save")
#
		## JSON provides a static method to serialized JSON string.
		#var json_string = JSON.stringify(node_data)
#
		## Store the save dictionary as a new line in the save file.
		#write_stream.store_line(json_string)
#
#
#func delete_save() -> void:
	#DirAccess.remove_absolute(save_file_path)
	#
	#
#func new_game() -> void:
	#var write_stream = FileAccess.open(save_file_path, FileAccess.WRITE)
	#var json_object = {
		#"geo": 0
	#}
	#
	#var json_string = JSON.stringify(json_object)
	#
	#write_stream.store_line(json_string)
