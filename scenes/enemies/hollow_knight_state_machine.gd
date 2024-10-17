extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("slashes")
	add_state("recover")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.is_target_in_aggro_range:
				return states.slashes
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if parent.is_target_in_aggro_range:
				return states.slashes
			elif parent.velocity.x == 0:
				return states.idle
		states.slashes:
			if parent.is_recovering:
				return states.recover
		states.recover:
			if !parent.is_recovering:
				if parent.velocity.x == 0:
					return states.idle
				if parent.velocity.x != 0:
					return states.walk
	return null

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.animated_sprite.play("idle")
		states.walk:
			parent.animated_sprite.play("walk")
		states.slashes:
			parent.animation_player.play("slashes")
		states.recover:
			parent.animated_sprite.play("recover")
	
func _exit_state(_old_state, _new_state):
	pass
