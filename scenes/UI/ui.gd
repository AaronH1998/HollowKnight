extends CanvasLayer

@onready var status_details_box: HBoxContainer = $TopLeft/StatusDetails
@onready var frame_animated_sprite: AnimatedSprite2D = $TopLeft/StatusDetails/Frame/FrameAnimatedSprite

var health_ui_scene: PackedScene = preload("res://scenes/UI/health.tscn")

func _ready():
	_animation_to_animation(frame_animated_sprite, "appear", "idle")
	
	for i in Globals.max_health:
		var health_ui = health_ui_scene.instantiate()
		health_ui.health_indicator = i + 1
		status_details_box.add_child(health_ui)

func _animation_to_animation(animated_sprite: AnimatedSprite2D, animation_1: String, animation_2: String):
	animated_sprite.play(animation_1)
	await animated_sprite.animation_finished
	animated_sprite.play(animation_2)

