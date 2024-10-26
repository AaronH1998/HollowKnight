extends Node

signal health_change(old_health, new_health)
signal soul_change(new_soul)

var save_file: String

var near_floor: bool = false
var near_ceiling: bool = false

var level_preparing: bool = true

var UNIT_SIZE: float = 96.0

var camera_height: float
var CAMERA_LOCK_HEIGHT: float = -250.0

var camera_lock_areas: int = 0
var camera_vertical_locked: bool:
	get:
		return camera_lock_areas > 0

var horizontal_locks: Array[float]
var vertical_locks: Array[float]

var look_ups: Array[bool]
var look_downs: Array[bool]

var max_health: int = 5
var player_health: int = max_health:
	set(value):
		health_change.emit(player_health, value)
		player_health = value
		
var max_soul: int = 99
var soul_gain: int = 11
var player_soul: int = max_soul:
	set(value):
		var new_soul: int = value
		if value > player_soul and player_soul == max_soul:
			return
		elif value < player_soul and player_soul == 0:
			return
		elif value > player_soul and value > max_soul:
			new_soul = max_soul
		elif value < player_soul and value < 0:
			new_soul = 0
		
		soul_change.emit(new_soul)
		player_soul = new_soul

var player_pos: Vector2

enum Action{
	NONE,
	SLASHES,
	TELEPORT
}

func reset():
	player_health = max_health
	player_soul = max_soul
