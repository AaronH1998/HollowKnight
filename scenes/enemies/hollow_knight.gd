extends Enemy

var hollow_knight_health: int = 1250
var is_target_in_aggro_range: bool = false
var previous_direction: int = 0
var is_recovering: bool = false
var is_slashing: bool = false
var attack_damage: int = 1
var is_attacking: bool = false
var attack_direction: Vector2 = Vector2.ZERO
var action: Globals.Action = Globals.Action.NONE
var is_dashing: bool = false
var is_dash_recovering = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var slash_collion_box: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var slash_area: Area2D = $SlashHitBox
@onready var sequence_timer: Timer = $Timers/SequenceTimer
@onready var state_label: Label = $Text/Label

func _ready():
	super()
	health = hollow_knight_health
	sequence_timer.start()


func notNone(chooseAction: Globals.Action):
	return chooseAction != Globals.Action.NONE


func choose_next_action():
	action = Globals.Action.values().filter(notNone).pick_random()


func _apply_movement():
	var player_direction: Vector2 = (Globals.player_pos - global_position).normalized()
	if is_recovering:
		velocity.x = 0
	elif is_dashing:
		if is_on_wall():
			stop_dash()
		else:
			velocity.x = attack_direction.x * speed * 5
	elif is_slashing:
		velocity.x = attack_direction.x * speed * 3
	elif !is_target_in_aggro_range and !is_attacking:
		velocity.x = player_direction.x * speed
		attack_direction = player_direction
	else:
		velocity.x = 0
		attack_direction = player_direction
	
	var current_direction = sign(velocity.x)
	if current_direction != 0 and current_direction != previous_direction and !is_slashing and !is_dashing:
		animated_sprite.flip_h = current_direction > 0
		slash_area.scale.x = -current_direction
		previous_direction = current_direction
		
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
	

func teleport_attack():
	action = Globals.Action.SLASHES


func dash():
	is_dashing = true


func stop_dash():
	is_dashing = false
	is_dash_recovering = true
	
	
func stop_dash_recover():
	is_dash_recovering = false
	action = Globals.Action.NONE
	sequence_timer.start()
