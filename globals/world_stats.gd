extends Resource
class_name WorldStats

@export var geo: int = 0
@export var max_health: int = 5
@export var nail_upgrade: int = 0
@export var zone: String = "Not Started"
@export var time_elapsed = 0


func to_dict() -> Dictionary:
	var dict = {}
	dict["geo"] = geo
	dict["max_health"] = max_health
	dict["nail_upgrade"] = nail_upgrade
	dict["zone"] = zone
	dict["time_elapsed"] = time_elapsed
	return dict
