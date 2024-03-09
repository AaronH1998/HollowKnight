extends Node

signal health_change(old_health, new_health)

var near_floor: bool = false
var near_ceiling: bool = false

var level_preparing: bool = true

var UNIT_SIZE:float = 96.0

var camera_height: float
var CAMERA_LOCK_HEIGHT: float = -250.0

var camera_lock_areas: int = 0
var camera_vertical_locked: bool:
	get:
		return camera_lock_areas > 0
		
var can_look_up: bool = true
var can_look_down: bool = true

var max_health: int = 5
var player_health: int = max_health:
	set(value):
		health_change.emit(player_health, value)
		player_health = value
		
