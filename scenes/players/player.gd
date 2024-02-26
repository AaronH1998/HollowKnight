extends CharacterBody2D

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

var camera_reached_lock: bool

@onready var visual = $Visual
@onready var animation_player = $AnimationPlayer

@onready var normal_attack_timer = $Timers/NormalAttackTimer
@onready var alt_attack_timer = $Timers/AltAttackTimer
@onready var attack_timer = $Timers/AttackTimer
@onready var look_up_timer = $Timers/LookUpTimer
@onready var look_down_timer = $Timers/LookDownTimer

@onready var slash_sprite = $Visual/Slashes
@onready var player_sprite = $Visual/Knight

@onready var camera = $Visual/Camera2D
@onready var camera_horizontal_marker = $CameraPosition

@onready var state_label = $Visual/MarginContainer/Label

func _ready():
	gravity = 2.0 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2.0 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2.0 * gravity * min_jump_height)
	slash_sprite.visible = false


func _process(_delta):
	_handle_camera()


func _handle_camera():

	if Globals.camera_vertical_locked:
		if camera_reached_lock:
			camera.global_position.y = Globals.camera_height
		else:
			camera.global_position.y = lerp(camera.global_position.y, Globals.camera_height, 0.002)
		
	else:
		camera.global_position.y = lerp(camera.global_position.y, $CameraPosition.global_position.y, 0.002)
	camera_reached_lock =Globals.camera_height -camera.global_position.y  < 1


func _handle_move_input():
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed


func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func _apply_movement():
	if velocity.x > 0:
		if move_direction != 1:
			move_direction = 1
			scale.x = -1
	elif velocity.x < 0:
		if move_direction != -1:
			move_direction = -1
			scale.x = -1
	
	move_and_slide()


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



func _on_enemy_detection_area_body_entered(body):
	print(body)
