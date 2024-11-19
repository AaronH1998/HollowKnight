extends StateMachine

func _ready():
	add_state("rest_look_left")
	add_state("rest_look_right")
	add_state("break_free")
	add_state("idle")
	add_state("walk")
	add_state("slashes")
	add_state("recover")
	add_state("teleport")
	add_state("dash_antic")
	add_state("dash")
	add_state("dash_recover")
	add_state("counter")
	add_state("riposte")
	call_deferred("set_state", states.rest_look_left)

func _state_logic(delta):
	parent.state_label.text = states.find_key(state)
	parent._calculate_player_position()
	if not parent.is_resting:
		parent._apply_gravity(delta)
	if not parent.is_resting and not parent.is_breaking_free:
		parent._handle_movement()
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
			elif parent.action == Globals.Action.COUNTER:
				return states.counter
			elif parent.velocity.x != 0:
				return states.walk
		states.walk:
			if parent.action == Globals.Action.SLASHES:
				return states.slashes
			elif parent.action == Globals.Action.TELEPORT:
				return states.teleport
			elif parent.action == Globals.Action.DASH:
				return states.dash_antic
			elif parent.action == Globals.Action.COUNTER:
				return states.counter
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
		states.rest_look_left:
			if parent.is_breaking_free:
				return states.break_free
			if parent.player_direction > 0:
				return states.rest_look_right
		states.rest_look_right:
			if parent.is_breaking_free:
				return states.break_free
			if parent.player_direction < 0:
				return states.rest_look_left
		states.break_free:
			if !parent.is_breaking_free:
				return states.idle
		states.counter:
			if parent.is_riposting:
				return states.riposte
			if parent.action == Globals.Action.NONE:
				return states.idle
		states.riposte:
			if !parent.is_riposting:
				return states.idle
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
		states.rest_look_left:
			parent.animated_sprite.play("rest look left")
		states.rest_look_right:
			parent.animated_sprite.play("rest look right")
		states.break_free:
			parent.animation_player.play("break free")
		states.counter:
			parent.animation_player.play("counter")
		states.riposte:
			parent.animation_player.play("riposte")
	
func _exit_state(old_state, new_state):
	if old_state == states.rest_look_right and new_state == states.rest_look_left:
		parent.animated_sprite.play("rest look right return")
	if old_state == states.rest_look_left and new_state == states.rest_look_right:
		parent.animated_sprite.play("rest look left return")
