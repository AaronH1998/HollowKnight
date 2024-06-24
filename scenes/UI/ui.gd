extends CanvasLayer

@onready var health_indicators_container: GridContainer = $TopLeft/VBoxContainer/StatusDetails/HealthIndicators
@onready var frame_animated_sprite: AnimatedSprite2D = $TopLeft/VBoxContainer/StatusDetails/Frame/FrameAnimatedSprite
@onready var filling_soul: TextureRect = $TopLeft/VBoxContainer/StatusDetails/Frame/SoulMargin/FillingSoul
@onready var full_soul: TextureRect = $TopLeft/VBoxContainer/StatusDetails/Frame/SoulMargin/FullSoul
@onready var geo_indicator: Label = $TopLeft/VBoxContainer/MarginContainer/GeoIndicator/Label

var health_ui_scene: PackedScene = preload("res://scenes/UI/health.tscn")

func _ready():
	Globals.connect("soul_change", update_soul)
	Globals.connect("geo_change", update_geo)
	_animation_to_animation(frame_animated_sprite, "appear", "idle")
	update_geo(Globals.geo)
	
	for i in Globals.max_health:
		var health_ui = health_ui_scene.instantiate()
		health_ui.health_indicator = i + 1
		health_indicators_container.add_child(health_ui)
	
	if Globals.player_soul == Globals.max_soul:
		filling_soul.visible = false
		full_soul.visible = true
	else:
		filling_soul.visible = false
		full_soul.visible = true
		var soul_uv_translation = _get_soul_flask_proportion(Globals.player_soul)
		filling_soul.material.set_shader_parameter("mask_translation", soul_uv_translation)


func _animation_to_animation(animated_sprite: AnimatedSprite2D, animation_1: String, animation_2: String):
	animated_sprite.play(animation_1)
	await animated_sprite.animation_finished
	animated_sprite.play(animation_2)


func update_soul(new_soul):
	if new_soul == Globals.max_soul:
		filling_soul.visible = false
		full_soul.visible = true
	else:
		filling_soul.visible = true
		full_soul.visible = false
		var soul_uv_translation = _get_soul_flask_proportion(new_soul)
		filling_soul.material.set_shader_parameter("mask_translation", soul_uv_translation)
		
		
func update_geo(geo):
	geo_indicator.text = str(geo)


func _get_soul_flask_proportion(current_soul) -> float:
	return 1.0 - (float(current_soul)/ (Globals.max_soul))
