extends VBoxContainer

@onready var health_indicators_container: GridContainer = $StatusDetails/HealthIndicators
@onready var geo_label: Label = $MarginContainer/GeoIndicator/Label

@export var max_health: int
@export var geo: int

var health_ui_scene: PackedScene = preload("res://scenes/UI/static_health.tscn")

func display():
	for i in max_health:
		var health_ui = health_ui_scene.instantiate()
		health_indicators_container.add_child(health_ui)
	geo_label.text = str(geo)
