extends Enemy

signal start_fight
signal break_chains
signal dstab_land(pos)

@export var hollow_knight_health: int = 200
@export var attack_damage: int = 1

var action: Globals.Action = Globals.Action.NONE
var phase: Globals.Phase = Globals.Phase.ONE
var player_direction: int = -1
var attack_direction: int = player_direction
var jump_modifier: float
var dash_travel_max: float = 900.0
var dash_travel_current: float = 0.0
var dash_travel_start: float = 0.0
var evade_travel_max: float = 500.0
var evade_travel_current: float = 0.0
var evade_travel_start: float = 0.0
var walk_travel_max: float = 300.0
var walk_travel_current: float = 0.0
var walk_travel_start: float = 0.0
var jump_to_velocity: float = 0.0

var is_target_in_attack_range: bool = false
var is_recovering: bool = false
var is_slashing: bool = false
var is_attacking: bool = false
var is_dashing: bool = false
var is_dash_recovering: bool = false
var is_resting: bool = true
var is_countering: bool = false
var is_riposting: bool = false
var can_jump: bool = false
var is_jumping: bool = false
var is_screaming: bool = false
var is_breaking_free: bool = false
var is_transitioning: bool = false
var is_movement_locked: bool = true
var is_evading: bool = false
var is_walking: bool = false
var is_dstab: bool = false
var is_dstab_land: bool = false
var is_dstab_antic: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_sprite: AnimatedSprite2D = $EffectAnimatedSprite
@onready var slash_collion_box: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var slash_area: Area2D = $SlashHitBox
@onready var state_label: Label = $Text/Label
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var teleport_wall_detection: RayCast2D = $TeleportWallDetection
@onready var slashes_range: RayCast2D = $SlashesRange

@onready var sequence_timer: Timer = $Timers/SequenceTimer
@onready var initial_scream_timer: Timer = $Timers/InitalScreamTimer
@onready var scream_timer: Timer = $Timers/ScreamTimer

# To find audio for HK, use unity explorer on scarab:
# Boss Control -> Hollow Knight Boss -> PlayMakerFSM (Control) -> States -> Actions -> AudioPlayerOneShotSingle
@onready var scream_audio: AudioStreamPlayer2D = $Audio/Scream
@onready var dash_audio: AudioStreamPlayer2D = $Audio/Dash
@onready var teleport_audio: AudioStreamPlayer2D = $Audio/Teleport
@onready var jump_audio: AudioStreamPlayer2D = $Audio/Jump
@onready var land_audio: AudioStreamPlayer2D = $Audio/Land
@onready var counter_audio: AudioStreamPlayer2D = $Audio/Counter
@onready var riposte_audio: AudioStreamPlayer2D = $Audio/Riposte

const PHASE_ONE_HEALTH_THRESHOLD: int = 199


func _ready():
	super()
	health = hollow_knight_health


func _handle_movement():
	velocity.x = 0
	
	if is_jumping:
		if is_on_floor():
			stop_jump()
		else:
			velocity.x = speed * jump_modifier
	elif can_jump:
		if is_on_floor():
			velocity.y = -2000
			jump_modifier = randf_range(-5.0, 5.0)
		else:
			is_jumping = true
			can_jump = false
	if is_dashing:
		if (dash_travel_current >= dash_travel_max) or is_on_wall():
			stop_dash()
		else:
			velocity.x = attack_direction * speed * 5
			dash_travel_current = attack_direction * (global_position.x - dash_travel_start)
	elif is_slashing:
		velocity.x = attack_direction * speed * 3
	elif action == Globals.Action.EVADE:
		if !is_evading:
			is_evading = true
			evade_travel_start = global_position.x
		elif (is_evading and evade_travel_current >= evade_travel_max) or is_on_wall():
			is_evading = false
			action = Globals.Action.NONE
			sequence_timer.start()
			evade_travel_current = 0
		else:
			velocity.x = -attack_direction * speed * 5
			evade_travel_current = -attack_direction * (global_position.x - evade_travel_start)
	elif action == Globals.Action.WALK:
		if !is_walking:
			is_walking = true
			walk_travel_start = global_position.x
		elif (is_walking and walk_travel_current >= walk_travel_max) or is_on_wall():
			is_walking = false
			action = Globals.Action.NONE
			sequence_timer.start()
			walk_travel_current = 0
		else:
			velocity.x = attack_direction * speed
			walk_travel_current = attack_direction * (global_position.x - walk_travel_start)
	elif action == Globals.Action.DSTAB:
		if is_dstab_antic:
			velocity = Vector2.ZERO
		elif !is_dstab and !is_dstab_land:
			if is_on_floor():
				velocity.y = -2000
				jump_to_velocity = calculate_jump_velocity()
			else:
				velocity.x = jump_to_velocity
		elif !is_dstab_land and is_on_floor():
			is_dstab = false
			is_dstab_land = true
			dstab_land.emit(global_position)

			

func _apply_movement():
	move_and_slide()


func filter_actions(act: Globals.Action) -> bool:
	if act == Globals.Action.NONE:
		return false
	if act == Globals.Action.TELEPORT and teleport_wall_detection.is_colliding():
		return false
	if act == Globals.Action.WALK and slashes_range.is_colliding():
		return false
	if act == Globals.Action.SLASHES and !slashes_range.is_colliding():
		return false
	if act == Globals.Action.COUNTER and !slashes_range.is_colliding():
		return false
	if act == Globals.Action.EVADE and !slashes_range.is_colliding():
		return false
	return true


func choose_next_action():
	if health < PHASE_ONE_HEALTH_THRESHOLD and phase == Globals.Phase.ONE:
		is_transitioning = true
		phase = Globals.Phase.TWO
	
	#var actions = Globals.Action.values()
	var actions = [Globals.Action.DSTAB]
	var filtered_actions = actions.filter(filter_actions)
	action = filtered_actions.pick_random()
	face_player()


func _calculate_player_position():
	if Globals.player_pos.x < global_position.x:
		player_direction = -1
	if Globals.player_pos.x > global_position.x:
		player_direction = 1


func face(direction: int):
	animated_sprite.flip_h = direction < 0
	slash_area.scale.x = direction
	teleport_wall_detection.scale.x = direction
	slashes_range.scale.x = direction
	attack_direction = direction


func face_player():
	face(player_direction)


func start_break_free():
	is_breaking_free = true


func break_free():
	Globals.shake_camera(20,2)
	face(-1)
	break_chains.emit()


func fall():
	is_resting = false
	Globals.level_preparing = true


func land():
	land_audio.play()
	Globals.shake_camera(10,2)


func end_break_free():
	is_breaking_free = false


func scream(is_init:bool):
	if is_init:
		start_fight.emit()
		initial_scream_timer.start()
	else:
		scream_timer.start()
	Globals.level_preparing = true
	is_screaming = true
	scream_audio.play()
	Globals.shake_camera(20,2)


func end_scream():
	is_screaming = false
	is_transitioning = false
	is_movement_locked = false
	Globals.level_preparing = false
	sequence_timer.start()


func _on_attack_range_body_entered(_body):
	is_target_in_attack_range = true


func _on_attack_range_body_exited(_body):
	is_target_in_attack_range = false


func attack():
	is_attacking = true
	

func start_recover():
	is_recovering = true
	is_attacking = false


func end_recover():
	action = Globals.Action.NONE
	is_recovering = false
	sequence_timer.start()


func slash():
	is_slashing = true
	slash_collion_box.disabled = false
	
	
func stop_slash():
	is_slashing = false
	slash_collion_box.disabled = true


func _on_slash_hit_box_body_entered(body):
	if "hit" in body:
		body.hit(body.global_position, attack_damage)


func _on_sequence_timer_timeout():
	choose_next_action()


func teleport():
	global_position.x += 800 * attack_direction
	teleport_audio.play()


func appear():
	face_player()


func teleport_attack():
	action = Globals.Action.SLASHES


func dash():
	is_dashing = true
	dash_travel_start = global_position.x
	dash_audio.play()


func stop_dash():
	is_dashing = false
	is_dash_recovering = true
	dash_travel_current = 0


func stop_dash_recover():
	is_dash_recovering = false
	action = Globals.Action.NONE
	sequence_timer.start()


func counter_ready():
	is_countering = true
	effect_animation_sprite.visible = true
	effect_animation_sprite.play("counter flash")
	counter_audio.play()
	await effect_animation_sprite.animation_finished
	effect_animation_sprite.visible = false


func hit(direction, damage):
	if is_countering:
		is_countering = false
		is_riposting = true
		riposte_audio.play()
	else:
		super(direction, damage)


func counter_unready():
	is_countering = false


func stop_counter():
	action = Globals.Action.NONE
	sequence_timer.start()


func end_riposte():
	end_recover()
	is_riposting = false
	action = Globals.Action.NONE
	sequence_timer.start()


func jump():
	can_jump = true


func stop_jump():
	is_jumping = false
	land_audio.play()
	action = Globals.Action.NONE
	sequence_timer.start()


func dstab_antic():
	is_dstab_antic = true


func dbstab():
	is_dstab = true
	is_dstab_antic = false


func stop_dstab_land():
	is_dstab_land = false
	action = Globals.Action.NONE
	

func calculate_jump_velocity() -> float:
	var distance = Globals.player_pos.x - global_position.x
	distance -= attack_direction * 100
	var t_up = 2000 / gravity
	var v_x = distance/t_up
	return v_x
	
