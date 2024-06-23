extends Enemy

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var vengefly_health: int = 8
var is_target_in_aggro_range: bool = false
var previous_direction: int = 0


func _ready():
	super()
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 10.0
	navigation_agent.target_position = Globals.player_pos
	health = vengefly_health


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
		navigation_agent.target_position = Globals.player_pos
