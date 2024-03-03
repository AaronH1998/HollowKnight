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
			parent.crawlid_animated_sprite.play("idle")
		states.walk:
			parent.crawlid_animated_sprite.play("walk")
		states.death_air:
			parent.crawlid_animated_sprite.play("death air")
		states.death_land:
			parent.crawlid_animated_sprite.play("death land")

func _exit_state(old_state, new_state):
	pass
