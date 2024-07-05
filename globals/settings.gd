extends Node

signal volume_update(bus_name, value)

var config: ConfigFile = ConfigFile.new()
var settings_path: String = "user://settings.cfg"

func _ready():
	config.load(settings_path)
	default_volume_settings()

func update_volume(bus_name: String, value: float) -> void:
	config.set_value("Audio", bus_name, value)
	config.save("user://settings.cfg")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	volume_update.emit(bus_name, value)


func get_volume(bus_name: String) -> float:
	return config.get_value("Audio", bus_name)


func default_volume_settings():
	update_volume("Master", 0.5)
	update_volume("Music", 0.5)
	update_volume("Sound", 0.5)
