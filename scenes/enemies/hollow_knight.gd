extends Enemy

signal start_fight

var hollow_knight_health: int = 20
var is_target_in_aggro_range: bool = false
var previous_direction: int = 0
var is_recovering: bool = false
var is_slashing: bool = false
var attack_damage: int = 1
var is_attacking: bool = false
var attack_direction: Vector2 = Vector2.ZERO
var action: Globals.Action = Globals.Action.NONE
var is_dashing: bool = false
var is_dash_recovering: bool = false
var is_resting: bool = true
var is_player_left: bool = true
var is_breaking_free: bool = false
var is_countering: bool = false
var is_riposting: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_animation_sprite: AnimatedSprite2D = $EffectAnimatedSprite
@onready var slash_collion_box: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var slash_area: Area2D = $SlashHitBox
@onready var sequence_timer: Timer = $Timers/SequenceTimer
@onready var state_label: Label = $Text/Label
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var scream_audio: AudioStreamPlayer2D = $Audio/Scream
@onready var slash_audio: AudioStreamPlayer2D = $Audio/Attack
@onready var dash_audio: AudioStreamPlayer2D = $Audio/Dash
@onready var teleport_audio: AudioStreamPlayer2D = $Audio/Teleport
@onready var land_audio: AudioStreamPlayer2D = $Audio/Land
@onready var counter_audio: AudioStreamPlayer2D = $Audio/Counter
@onready var riposte_audio: AudioStreamPlayer2D = $Audio/Riposte

func _ready():
	super()
	health = hollow_knight_health


func start_break_free():
	is_breaking_free = true


func break_chains():
	Globals.shake_camera(20,2)


func fall():
	is_resting = false


func land():
	Globals.level_preparing = true
	land_audio.play()
	Globals.shake_camera(10,2)


func scream():
	scream_audio.play()
	start_fight.emit()
	Globals.shake_camera(20,2)


func end_break_free():
	Globals.level_preparing = false
	is_breaking_free = false
	sequence_timer.start()


func notNone(chooseAction: Globals.Action):
	return chooseAction != Globals.Action.NONE


func choose_next_action():
	action = Globals.Action.values().filter(notNone).pick_random()
	face(-1 if is_player_left else 1)


func _calculate_player_position():
	if Globals.player_pos.x < global_position.x:
		is_player_left = true
	if Globals.player_pos.x > global_position.x:
		is_player_left = false


func _handle_movement():
	var player_direction: Vector2 = (Globals.player_pos - global_position).normalized()
	if is_recovering or is_dash_recovering or (is_attacking and !is_slashing):
		velocity.x = 0
	elif is_dashing:
		if is_on_wall():
			stop_dash()
		else:
			velocity.x = attack_direction.x * speed * 5
	elif is_slashing:
		velocity.x = attack_direction.x * speed * 3
	elif !is_target_in_aggro_range and !is_attacking:
		face(-1 if is_player_left else 1)
		velocity.x = player_direction.x * speed
		attack_direction = player_direction
	else:
		velocity.x = 0
		attack_direction = player_direction


func face(new_direction):
	animated_sprite.flip_h = new_direction < 0
	slash_area.scale.x = -new_direction
	previous_direction = new_direction


func _apply_movement():
	move_and_slide()


func _on_attack_range_body_entered(_body):
	is_target_in_aggro_range = true


func _on_attack_range_body_exited(_body):
	is_target_in_aggro_range = false


func attack():
	action = Globals.Action.NONE
	is_attacking = true


func start_recover():
	is_recovering = true
	is_attacking = false


func end_recover():
	is_recovering = false
	start_sequence_timer()


func slash():
	is_slashing = true
	slash_collion_box.disabled = false
	slash_audio.play()
	
	
func stop_slash():
	is_slashing = false
	slash_collion_box.disabled = true


func _on_slash_hit_box_body_entered(body):
	if "hit" in body:
		body.hit(body.global_position, attack_damage)


func start_sequence_timer():
	sequence_timer.start()


func _on_sequence_timer_timeout():
	choose_next_action()


func teleport():
	global_position.x += 800 * previous_direction
	teleport_audio.play()


func appear():
	face(-1 if is_player_left else 1)


func teleport_attack():
	action = Globals.Action.SLASHES


func dash():
	is_dashing = true
	dash_audio.play()


func stop_dash():
	is_dashing = false
	is_dash_recovering = true


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
