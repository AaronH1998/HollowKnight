extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("death_air")
	add_state("death_land")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.dead:
				if parent.is_on_floor():
					return states.death_land
				else:
					return states.death_air
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if parent.dead:
				if parent.is_on_floor():
					return states.death_land
				else:
					return states.death_air
			elif parent.velocity.x == 0:
				return states.idle
		states.death_air:
			if parent.is_on_floor():
				return states.death_land
		states.death_land:
			pass
	return null

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.animated_sprite.play("idle")
		states.walk:
			parent.animated_sprite.play("walk")
			parent.walk_audio.play()
		states.death_air:
			parent.animated_sprite.play("death air")
		states.death_land:
			parent.animated_sprite.play("death land")

func _exit_state(_old_state, _new_state):
	parent.walk_audio.stop()
