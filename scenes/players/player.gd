extends CharacterBody2D

signal player_death

var cast_soul: int = 33
var healing_power: int = 1
var healing: bool = false
var focussing: bool = false
var is_right_click: bool = false

var speed: float = 4 * Globals.UNIT_SIZE
var min_jump_height: float = 0.2 * Globals.UNIT_SIZE
var max_jump_height: float = 3 * Globals.UNIT_SIZE
var min_jump_velocity: float
var max_jump_velocity: float
var jump_duration: float = 0.5
var gravity: float
var move_direction: int = 1

var jumping: bool = false
var looking_up: bool = false
var looking_down: bool = false
var camera_modifier: int
var camera_reached_lock: bool

var knockback: Vector2 = Vector2.ZERO

var normal_attacking: bool = false
var alt_attacking: bool = false
var up_attacking: bool = false
var down_attacking: bool = false
var normal_attack_mode: bool = true
var can_attack: bool = true

var attack_damage: int = 5
var dead: bool = false
var damaged: bool = false
var vulnerable: bool = true

var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")

@onready var visual = $Visual
@onready var knight_animated_sprite: AnimatedSprite2D = $Visual/KnightAnimatedSprite
@onready var slash_animated_sprite: AnimatedSprite2D = $Visual/SlashAnimatedSprite
@onready var alt_slash_animated_sprite: AnimatedSprite2D = $Visual/AltSlashAnimatedSprite
@onready var up_slash_animated_sprite: AnimatedSprite2D = $Visual/UpSlashAnimatedSprite
@onready var down_slash_animated_sprite: AnimatedSprite2D = $Visual/DownSlashAnimatedSprite

@onready var look_up_timer: Timer = $Timers/LookUpTimer
@onready var look_down_timer: Timer = $Timers/LookDownTimer
@onready var hit_timer: Timer = $Timers/HitTimer

@onready var camera: Camera2D = $Visual/Camera2D
@onready var camera_marker: Marker2D = $CameraPosition

@onready var state_label: Label = $Visual/MarginContainer/Label

@onready var walk_audio = $Audio/Walk
@onready var jump_audio = $Audio/Jump
@onready var fall_audio = $Audio/Fall
@onready var land_audio = $Audio/Land
@onready var attack_normal_audio = $Audio/AttackNormal
@onready var attack_alt_audio = $Audio/AttackAlt
@onready var attack_up_audio = $Audio/AttackUp
@onready var attack_down_audio = $Audio/AttackDown
@onready var damage_audio = $Audio/Damage
@onready var death_audio = $Audio/Death
@onready var focus_health_charge_audio = $Audio/FocusHealthCharge
@onready var focus_health_heal_audio = $Audio/FocusHealthHeal

@onready var action_animation_player = $ActionAnimationPlayer
@onready var secondary_animation_player = $SecondaryAnimationPlayer

@onready var collision_shape = $CollisionShape2D
@onready var enemy_detection_area = $EnemyDetectionArea
@onready var front_attack_area = $FrontAttackArea


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
	
	camera.position.x = camera_marker.position.x
	camera_reached_lock = Globals.camera_height - camera.global_position.y  < 1


func _handle_move_input():
	var direction = int(Input.get_axis("left", "right"))
	
	if direction != 0 and direction != move_direction:
		knight_animated_sprite.scale.x *= -1
		slash_animated_sprite.scale.x *= -1
		collision_shape.scale.x *= -1
		enemy_detection_area.scale.x *= -1
		front_attack_area.scale.x *= -1
		alt_slash_animated_sprite.scale.x *= -1
		up_slash_animated_sprite.scale.x *= -1
		down_slash_animated_sprite.scale.x *= -1
		camera_marker.position.x = -camera_marker.position.x
		move_direction = direction
	
	velocity.x = direction * speed
	velocity += knockback
	if(velocity.y < max_jump_velocity):
		velocity.y = max_jump_velocity


func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func _apply_movement():
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.4)
	Globals.player_pos = global_position


func _on_look_up_timer_timeout():
	camera_modifier = -100


func _on_look_down_timer_timeout():
	camera_modifier = 100


func _on_enemy_detection_area_body_entered(body):
	var damage = 1
	var pos = body.global_position
	hit(pos, damage)


func reset_state():
	$FrontAttackArea/CollisionPolygon2D.call_deferred("set_disabled", true)
	$UpAttackArea/CollisionPolygon2D.call_deferred("set_disabled", true)
	$DownAttackArea/CollisionPolygon2D.call_deferred("set_disabled", true)
	up_attacking = false
	down_attacking = false
	normal_attacking = false
	healing = false
	can_attack = true
	

func hit(pos: Vector2, damage: int):
	if !vulnerable or dead:
		return
	
	vulnerable = false
	damaged = true
	reset_state()
	
	var knockback_strength = Vector2(9000.0, 400.0)
	var direction = pos.direction_to(global_position)
	apply_knockback(direction, knockback_strength)
	frame_freeze(0.05, 0.4)
	hit_timer.start()
	
	Globals.player_health -= damage
	if Globals.player_health <= 0:
		_die()


func apply_knockback(direction, strength):
	var force = Vector2(direction.x * strength.x, -strength.y)
	knockback = force


func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration * time_scale).timeout)
	Engine.time_scale = 1


func _die():
	dead = true


func _recover():
	damaged = false


func _dead():
	knight_animated_sprite.visible = false
	player_death.emit()
	Globals.player_health = Globals.max_health


func _on_damaged_timer_timeout():
	damaged = false

	
func _on_hit_timer_timeout():
	vulnerable = true


func stop_attack():
	normal_attacking = false
	alt_attacking = false
	up_attacking = false
	down_attacking = false
	normal_attack_mode = true
	can_attack = true


func toggle_normal_attack_mode():
	normal_attack_mode = !normal_attack_mode
	can_attack = true


func attack_body(body, direction):
	if "hit" in body:
		body.hit(direction, attack_damage)
		Globals.player_soul += Globals.soul_gain


func _on_front_attack_area_body_entered(body):
	var direction = Vector2.RIGHT * move_direction
	attack_body(body, direction)
	apply_knockback(-direction, Vector2(1000, 0))


func _on_up_attack_area_body_entered(body):
	var direction = Vector2.UP
	attack_body(body, direction)


func _on_down_attack_area_body_entered(body):
	var direction = Vector2.DOWN
	attack_body(body, direction)
	knockback.y = 0
	velocity.y = max_jump_velocity


func _heal():
	if Globals.player_soul >= cast_soul:
		Globals.player_soul -= cast_soul
		healing = true
		focussing = false
		if Globals.player_health < Globals.max_health:
			Globals.player_health += healing_power


func _finish_heal():
	healing = false
	if Globals.player_soul >= cast_soul and is_right_click:
		focussing = true

func kill():
	Globals.player_health = 0
	_die()
