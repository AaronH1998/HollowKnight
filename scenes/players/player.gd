extends CharacterBody2D

var speed: float = 4 * Globals.UNIT_SIZE
var min_jump_height: float = 0.8 * Globals.UNIT_SIZE
var max_jump_height: float = 3 * Globals.UNIT_SIZE
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
var looking_up: bool = false
var looking_down: bool = false
var camera_modifier: int
var camera_reached_lock: bool

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = 750.0
var knockback: Vector2 = Vector2.ZERO

var targets = []
var attack_damage: int = 5
var dead: bool = false
var damaged: bool = false
var vulnerable: bool = true

var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")

@onready var visual = $Visual
@onready var knight_animated_sprite: AnimatedSprite2D = $Visual/KnightAnimatedSprite
@onready var slash_animated_sprite: AnimatedSprite2D = $Visual/SlashAnimatedSprite

@onready var normal_attack_timer: Timer = $Timers/NormalAttackTimer
@onready var alt_attack_timer: Timer = $Timers/AltAttackTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var look_up_timer: Timer = $Timers/LookUpTimer
@onready var look_down_timer: Timer = $Timers/LookDownTimer
@onready var hit_timer: Timer = $Timers/HitTimer

@onready var camera: Camera2D = $Visual/Camera2D
@onready var camera_marker: Marker2D = $Markers/CameraPosition

@onready var state_label: Label = $Visual/MarginContainer/Label

@onready var standard_slash_marker: Marker2D = $Markers/StandardSlashMarker
@onready var down_slash_marker: Marker2D = $Markers/DownSlashMarker

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

@onready var animation_player = $AnimationPlayer

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
	var direction = int(Input.get_axis("left", "right"))
	
	if direction != 0 and direction != move_direction:
		knight_animated_sprite.scale.x *= -1
		slash_animated_sprite.scale.x *= -1
		$CollisionShape2D.scale.x *= -1
		$EnemyDetectionArea.scale.x *= -1
		$AttackArea.scale.x *= -1
		move_direction = direction
	
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
	var damage = 1
	var pos = body.global_position
	hit(pos, damage)


func hit(pos, damage):
	if !vulnerable or dead:
		return
		
	damaged = true
	vulnerable = false
	
	var direction = pos.direction_to(global_position)
	var force = Vector2(direction.x * knockback_strength_x, direction.y * knockback_strength_y)
	knockback = force
	frame_freeze(0.05, 0.4)
	hit_timer.start()
	animation_player.play("invulnerable")
	
	Globals.player_health -= damage
	if Globals.player_health <= 0:
		_die()


func frame_freeze(time_scale, duration):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration * time_scale).timeout)
	Engine.time_scale = 1


func _die():
	dead = true


func _dead():
	var death_mask = death_mask_scene.instantiate() as RigidBody2D
	death_mask.position = knight_animated_sprite.position
	knight_animated_sprite.visible = false
	
	add_child(death_mask)

func _on_attack_area_body_entered(body):
	if "hit" in body:
		targets.append(body)


func _on_attack_area_body_exited(body):
	if "hit" in body:
		var index = targets.find(body)
		targets.remove_at(index)


func attack_targets():
	for body in targets:
		body.hit(global_position, attack_damage)


func _on_damaged_timer_timeout():
	damaged = false


func _on_hit_timer_timeout():
	vulnerable = true
