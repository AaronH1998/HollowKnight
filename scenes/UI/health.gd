extends MarginContainer

@export var health_indicator: int
@onready var health_animated_sprite: AnimatedSprite2D = $HealthAnimatedSprite

func _ready():
	print(health_indicator)
	Globals.connect("health_change", update_health)
	_animation_to_animation(health_animated_sprite, "appear", "idle")

func update_health(old_health, new_health):
	if health_indicator <= old_health and health_indicator > new_health:
		_animation_to_animation(health_animated_sprite, "break", "empty")

func _animation_to_animation(animated_sprite: AnimatedSprite2D, animation_1: String, animation_2: String):
	animated_sprite.play(animation_1)
	await animated_sprite.animation_finished
	animated_sprite.play(animation_2)
