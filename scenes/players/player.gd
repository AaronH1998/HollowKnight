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

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = 1000.0
var knockback: Vector2 = Vector2.ZERO

var targets = []

@onready var knight_animated_sprite: AnimatedSprite2D = $Visual/KnightAnimatedSprite
@onready var slash_animated_sprite: AnimatedSprite2D = $Visual/SlashAnimatedSprite

@onready var normal_attack_timer: Timer = $Timers/NormalAttackTimer
@onready var alt_attack_timer: Timer = $Timers/AltAttackTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var look_up_timer: Timer = $Timers/LookUpTimer
@onready var look_down_timer: Timer = $Timers/LookDownTimer

@onready var camera: Camera2D = $Visual/Camera2D
@onready var camera_marker: Marker2D = $Markers/CameraPosition

@onready var state_label: Label = $Visual/MarginContainer/Label

@onready var standard_slash_marker: Marker2D = $Markers/StandardSlashMarker
@onready var down_slash_marker: Marker2D = $Markers/DownSlashMarker


func _ready():
	gravity = 2.0 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2.0 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2.0 * gravity * min_jump_height)


func _process(_delta):
	_handle_camera()


func _handle_camera():
	var cam_mod: float
	if Globals.can_look_up and camera_modifier < 0:
		cam_mod = camera_modifier
	elif Globals.can_look_down and camera_modifier > 0:
		cam_mod = camera_modifier

	if Globals.camera_vertical_locked:
		if camera_reached_lock:
			camera.global_position.y = Globals.camera_height + cam_mod
		else:
			camera.global_position.y = lerp(camera.global_position.y, Globals.camera_height + cam_mod, 0.002)
		
	else:
		camera.global_position.y = lerp(camera.global_position.y, camera_marker.global_position.y + cam_mod, 0.002)
	
	camera_reached_lock = Globals.camera_height - camera.global_position.y  < 1


func _handle_move_input():
	var direction = Input.get_axis("left", "right")
	
	if direction > 0:
		if move_direction != 1:
			move_direction = 1
			scale.x = -1
	elif direction < 0:
		if move_direction != -1:
			move_direction = -1
			scale.x = -1
			
	velocity.x = direction * speed
	velocity += knockback


func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func _apply_movement():
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.4)


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
	var direction = body.global_position.direction_to(global_position)
	var force = Vector2(direction.x * knockback_strength_x, direction.y * knockback_strength_y)
	knockback = force


func _on_attack_area_body_entered(body):
	if "hit" in body:
		targets.append(body)


func _on_attack_area_body_exited(body):
	if "hit" in body:
		var index = targets.find(body)
		targets.remove_at(index)


func attack_targets():
	for body in targets:
		body.hit(global_position)
