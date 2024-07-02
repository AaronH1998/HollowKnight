extends Node

signal geo_change(geo)

var save_file_path: String

var world_stats: WorldStats = WorldStats.new()

var time_start
var time_on_save

func reset():
	world_stats = WorldStats.new()


func save_game():
	if(time_start):
		time_on_save = Time.get_ticks_usec()
		world_stats.time_elapsed += time_on_save - time_start
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
	time_start = Time.get_ticks_usec()


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
	
	return json_object
