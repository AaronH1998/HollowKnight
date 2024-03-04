extends CanvasLayer

@onready var frame_animated_sprite: AnimatedSprite2D = $MarginContainer/HBoxContainer/Frame/FrameAnimatedSprite
@onready var health_animated_sprite_1: AnimatedSprite2D = $MarginContainer/HBoxContainer/Health1/HealthAnimatedSprite1
@onready var health_animated_sprite_2: AnimatedSprite2D = $MarginContainer/HBoxContainer/Health2/HealthAnimatedSprite2
@onready var health_animated_sprite_3: AnimatedSprite2D = $MarginContainer/HBoxContainer/Health3/HealthAnimatedSprite3
@onready var health_animated_sprite_4: AnimatedSprite2D = $MarginContainer/HBoxContainer/Health4/HealthAnimatedSprite4
@onready var health_animated_sprite_5: AnimatedSprite2D = $MarginContainer/HBoxContainer/Health5/HealthAnimatedSprite5

var previous_player_health: int = 5

var health_animated_sprites: Array

func _ready():
	Globals.connect("health_change", update_health)
	_animation_to_animation(frame_animated_sprite, "appear", "idle")
	health_animated_sprites = [health_animated_sprite_1, health_animated_sprite_2, health_animated_sprite_3, health_animated_sprite_4, health_animated_sprite_5]
	for animated_sprite in health_animated_sprites:
		_animation_to_animation(animated_sprite, "appear", "idle")


func update_health(old_health, new_health):
	for index in len(health_animated_sprites):
		if index > new_health - 1 and index < old_health:
			_animation_to_animation(health_animated_sprites[index], "break", "empty")


func _process(delta):
	if Globals.player_health != previous_player_health:
		previous_player_health = Globals.player_health


func _animation_to_animation(animated_sprite: AnimatedSprite2D, animation_1: String, animation_2: String):
	animated_sprite.play(animation_1)
	await animated_sprite.animation_finished
	animated_sprite.play(animation_2)

