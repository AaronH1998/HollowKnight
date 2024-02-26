extends Node2D

var speed: float = 4 * Globals.UNIT_SIZE
var min_jump_height: float = 0.8 * Globals.UNIT_SIZE
var max_jump_height: float = 5 * Globals.UNIT_SIZE
var min_jump_velocity: float
var max_jump_velocity: float
var jump_duration: float = 0.5
var gravity: float
var move_direction: int = 1

var jumping: bool = false
var normal_attacking: bool = false
var can_normal_attack: bool = true
var alt_attacking: bool = false
var can_alt_attack: bool = false
var up_attacking: bool = false
var down_attacking: bool = false
var looking_up:bool = false
var looking_down:bool = false
var camera_modifier: int

@onready var physics: CharacterBody2D = $PlayerPhysics
@onready var visual = $Visual
@onready var animation_player = $AnimationPlayer

@onready var normal_attack_timer = $Timers/NormalAttackTimer
@onready var alt_attack_timer = $Timers/AltAttackTimer
@onready var attack_timer = $Timers/AttackTimer
@onready var look_up_timer = $Timers/LookUpTimer
@onready var look_down_timer = $Timers/LookDownTimer

@onready var slash_sprite = $Visual/Smoothing2D/Slashes
@onready var player_sprite = $Visual/Smoothing2D/Knight

@onready var camera = $Camera2D
@onready var camera_horizontal_marker = $PlayerPhysics/CameraPosition

@onready var state_label = $Visual/Smoothing2D/MarginContainer/Label

func _ready():
	gravity = 2.0 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2.0 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2.0 * gravity * min_jump_height)
	slash_sprite.visible = false


func _process(_delta):
	if physics.velocity.x < 0:
		visual.scale.x = -1
	elif physics.velocity.x > 0: 
		visual.scale.x = 1
	
	_handle_camera()


func _handle_camera():
	if Globals.near_floor or Globals.near_ceiling:
		camera.global_position = camera.global_position.lerp(Vector2(camera.global_position.x, (Globals.camera_height + camera_modifier)), 0.002)
	else:
		camera.global_position = camera.global_position.lerp(Vector2(camera.global_position.x, (player_sprite.global_position.y + camera_modifier)), 0.002)
	camera.global_position.x = camera_horizontal_marker.global_position.x


func _handle_move_input():
	var direction = Input.get_axis("left", "right")
	physics.velocity.x = direction * speed


func _apply_gravity(delta):
	if physics.velocity.y < 2000:
		physics.velocity.y += gravity * delta


func _apply_movement():
	if physics.velocity.x > 0:
		if move_direction != 1:
			move_direction = 1
			physics.scale.x = -1
	elif physics.velocity.x < 0:
		if move_direction != -1:
			move_direction = -1
			physics.scale.x = -1
	
	physics.move_and_slide()


func _on_alt_attack_timer_timeout():
	can_normal_attack = true


func _on_normal_attack_timer_timeout():
	can_alt_attack = true


func _on_attack_timer_timeout():
	normal_attacking = false
	alt_attacking = false
	up_attacking = false
	down_attacking = false
	can_alt_attack = false
	can_normal_attack = true


func _on_look_up_timer_timeout():
	camera_modifier = -100


func _on_look_down_timer_timeout():
	camera_modifier = 100

