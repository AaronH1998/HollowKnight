extends StateMachine

func _ready():
	add_state("idle")
	add_state("fly")
	add_state("death_air")
	add_state("death_land")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	if(parent.dead):
		parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.dead:
				return states.death_air
			elif parent.velocity.x != 0:
				return states.fly
		states.fly:
			if parent.dead:
				return states.death_air
			elif parent.velocity.x == 0:
				return states.idle
		states.death_air:
			pass
	return null

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.animated_sprite.play("idle")
		states.fly:
			parent.animated_sprite.play("fly")
		states.death_air:
			parent.animated_sprite.play("death air")

func _exit_state(_old_state, _new_state):
	pass
