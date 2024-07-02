extends Resource
class_name WorldStats

@export var geo = 0
@export var max_health = 5
@export var nail_upgrade = 0


func to_dict() -> Dictionary:
	var dict = {}
	dict["geo"] = geo
	dict["max_health"] = max_health
	dict["nail_upgrade"] = nail_upgrade
	return dict
