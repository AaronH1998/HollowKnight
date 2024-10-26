extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("slashes")
	add_state("recover")
	add_state("teleport")
	add_state("dash_antic")
	add_state("dash")
	add_state("dash_recover")
	call_deferred("set_state", states.idle)

func _state_logic(delta):
	parent.state_label.text = states.find_key(state)
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.action == Globals.Action.SLASHES:
				return states.slashes
			elif parent.action == Globals.Action.TELEPORT:
				return states.teleport
			elif parent.action == Globals.Action.DASH:
				return states.dash_antic
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if parent.action == Globals.Action.SLASHES:
				return states.slashes
			elif parent.action == Globals.Action.TELEPORT:
				return states.teleport
			elif parent.action == Globals.Action.DASH:
				return states.dash_antic
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
		states.teleport:
			if parent.action == Globals.Action.SLASHES:
				return states.slashes
		states.dash_antic:
			if parent.is_dashing:
				return states.dash
		states.dash:
			if !parent.is_dashing:
				return states.dash_recover
		states.dash_recover:
			if !parent.is_dash_recovering:
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
		states.teleport:
			parent.animation_player.play("teleport")
		states.dash_antic:
			parent.animation_player.play("dash antic")
		states.dash:
			parent.animated_sprite.play("dash")
		states.dash_recover:
			parent.animation_player.play("dash recover")
	
func _exit_state(_old_state, _new_state):
	pass
