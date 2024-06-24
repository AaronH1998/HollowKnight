extends CharacterBody2D
class_name Enemy

signal enemy_hit(pos, dir)
signal death(pos, dir, geo)

var gravity: float = 3848.0
var speed: float = 2 * Globals.UNIT_SIZE
var move_direction: int = 1

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = 750.0
var knockback: Vector2 = Vector2.ZERO
var inital_sprite_scale_x: float

var health: int = 8;

var dead: bool = false

var geo: int = 2

@onready var hit_audio: AudioStreamPlayer2D = $Audio/Hit
@onready var die_audio: AudioStreamPlayer2D = $Audio/Die
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	inital_sprite_scale_x = $AnimatedSprite2D.scale.x

func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func hit(direction, damage):
	health -= damage

	var force = Vector2(direction.x * knockback_strength_x, direction.y * knockback_strength_y)
	knockback = force
	hit_audio.play()
	enemy_hit.emit(global_position, direction)
	
	if(health <= 0):
		_die(direction)


func _die(dir):
	dead = true
	speed = 0
	die_audio.play()	
	_disable_player_collision()
	death.emit(global_position, dir, geo)


func _disable_player_collision():
	set_collision_layer_value(2, false)
	set_collision_layer_value(7, true)


func kill():
	if !dead:
		health = 0
		_die(Vector2.ZERO)
