extends Node

signal volume_update(bus_name, value)

var config: ConfigFile = ConfigFile.new()

const SETTINGS_PATH = "user://settings.cfg"
const AUDIO_SETTING_NAME = "Audio"
const MASTER_BUS_NAME = "Master"
const SOUND_BUS_NAME = "Sound"
const MUSIC_BUS_NAME = "Music"


func _ready():
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		default_volume_settings()
		
	var master_volume = config.get_value(AUDIO_SETTING_NAME, MASTER_BUS_NAME)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS_NAME), linear_to_db(master_volume))
	
	var sound_volume = config.get_value(AUDIO_SETTING_NAME, SOUND_BUS_NAME)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SOUND_BUS_NAME), linear_to_db(sound_volume))
	
	var music_volume = config.get_value(AUDIO_SETTING_NAME, MUSIC_BUS_NAME)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS_NAME), linear_to_db(music_volume))


func update_volume(bus_name: String, value: float) -> void:
	config.set_value(AUDIO_SETTING_NAME, bus_name, value)
	config.save(SETTINGS_PATH)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))
	volume_update.emit(bus_name, value)


func up_volume(bus_name: String) -> void:
	var volume = config.get_value(AUDIO_SETTING_NAME, bus_name)
	if volume < 1:
		update_volume(bus_name, volume + 0.1)


func down_volume(bus_name: String) -> void:
	var volume = config.get_value(AUDIO_SETTING_NAME, bus_name)
	if(volume > 0):
		update_volume(bus_name, volume - 0.1)
	

func get_volume(bus_name: String) -> float:
	return config.get_value(AUDIO_SETTING_NAME, bus_name)


func default_volume_settings() -> void:
	update_volume(MASTER_BUS_NAME, 0.5)
	update_volume(SOUND_BUS_NAME, 0.5)
	update_volume(MUSIC_BUS_NAME, 0.5)
