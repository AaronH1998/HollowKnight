extends CharacterBody2D

var speed: float = 2 * Globals.UNIT_SIZE
var previous_direction = 0

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = 750.0
var knockback: Vector2 = Vector2.ZERO
var inital_sprite_scale_x: float
var is_target_in_aggro_range: bool = false
var move_direction: int = 1
var gravity:float = 3848.0

var health: int = 8

var dead: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	inital_sprite_scale_x = animated_sprite.scale.x
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 10.0
	navigation_agent.target_position = Globals.player_pos


func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func _apply_movement():
	
	if dead:
		velocity.x = 0
	elif !is_target_in_aggro_range:
		velocity = Vector2.ZERO
	elif(navigation_agent.is_navigation_finished()):
		velocity = Vector2.ZERO
	else:
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_pos - global_position).normalized()
		velocity = direction * speed
	
	var current_direction = sign(velocity.x)
	if current_direction != 0 and current_direction != previous_direction:
		animated_sprite.flip_h = current_direction > 0
		previous_direction = current_direction
	
	velocity += knockback
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.6)


func _on_aggro_range_body_entered(_body):
	is_target_in_aggro_range = true


func _on_aggro_range_body_exited(_body):
	is_target_in_aggro_range = false


func _on_navigation_timer_timeout():
	if is_target_in_aggro_range:
		$NavigationAgent2D.target_position = Globals.player_pos


func hit(direction, damage):
	health -= damage

	var force = Vector2(direction.x * knockback_strength_x, direction.y * knockback_strength_y)
	knockback = force
	
	if(health <= 0):
		_die()


func _die():
	dead = true
	speed = 0
	_disable_player_collision()
	

func _disable_player_collision():
	set_collision_layer_value(2, false)
	set_collision_layer_value(7, true)
