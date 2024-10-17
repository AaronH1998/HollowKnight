extends Enemy

var hollow_knight_health: int = 1250
var is_target_in_aggro_range: bool = false
var previous_direction: int = 0
var is_recovering: bool = false
var is_slashing: bool = false
var attack_damage: int = 1
var is_attacking: bool = false
var attack_direction: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var slash_collion_box: CollisionPolygon2D = $SlashHitBox/CollisionPolygon2D
@onready var slash_area: Area2D = $SlashHitBox

func _ready():
	super()
	health = hollow_knight_health


func _apply_movement():
	var player_direction: Vector2 = (Globals.player_pos - global_position).normalized()
	if is_recovering:
		velocity.x = 0
	elif is_slashing:
		velocity.x = attack_direction.x * speed * 3
	elif !is_target_in_aggro_range and !is_attacking:
		velocity.x = player_direction.x * speed
	else:
		velocity.x = 0
		
	if(!is_slashing):
		attack_direction = player_direction
	
	var current_direction = sign(velocity.x)
	if current_direction != 0 and current_direction != previous_direction:
		animated_sprite.flip_h = current_direction > 0
		slash_area.scale.x = -current_direction
		previous_direction = current_direction
		
	move_and_slide()


func _on_attack_range_body_entered(_body):
	is_target_in_aggro_range = true


func _on_attack_range_body_exited(_body):
	is_target_in_aggro_range = false


func attack():
	is_attacking = true

func start_recover():
	is_recovering = true
	is_attacking = false


func end_recover():
	is_recovering = false


func slash():
	is_slashing = true
	slash_collion_box.disabled = false
	
	
func stop_slash():
	is_slashing = false
	slash_collion_box.disabled = true


func _on_slash_hit_box_body_entered(body):
	if "hit" in body:
		body.hit(body.global_position, attack_damage)
