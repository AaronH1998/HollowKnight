extends StateMachine

func _ready():
	add_state("rest_look_left")
	add_state("rest_look_right")
	add_state("break_free")
	add_state("idle")
	add_state("slashes")
	add_state("recover")
	add_state("teleport")
	add_state("dash_antic")
	add_state("dash")
	add_state("dash_recover")
	add_state("counter")
	add_state("riposte")
	add_state("jump_antic")
	add_state("jump")
	add_state("roar_init")
	add_state("scream")
	add_state("roar_antic")
	add_state("roar_recover")
	add_state("evade")
	call_deferred("set_state", states.rest_look_left)

func _state_logic(delta):
	parent.state_label.text = states.find_key(state)
	parent._calculate_player_position()
	if !parent.is_resting:
		parent._apply_gravity(delta)
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
			elif parent.action == Globals.Action.JUMP:
				return states.jump_antic
			elif parent.action == Globals.Action.EVADE:
				return states.evade
			elif parent.is_transitioning:
				return states.roar_antic
		states.slashes:
			if parent.is_recovering:
				return states.recover
		states.recover:
			if !parent.is_recovering:
				return states.idle
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
				return states.idle
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
				return states.roar_init
		states.counter:
			if parent.is_riposting:
				return states.riposte
			if parent.action == Globals.Action.NONE:
				return states.idle
		states.riposte:
			if !parent.is_riposting:
				return states.idle
		states.jump_antic:
			if parent.can_jump:
				return states.jump
		states.jump:
			if !parent.is_jumping and !parent.can_jump:
				return states.recover
		states.roar_init:
			if parent.is_screaming:
				return states.scream
		states.scream:
			if !parent.is_screaming:
				return states.roar_recover
		states.roar_antic:
			if parent.is_screaming:
				return states.scream
		states.roar_recover:
			if !parent.is_recovering:
				return states.idle
		states.evade:
			if parent.action != Globals.Action.EVADE:
				return states.idle
				
	return null

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.animated_sprite.play("idle")
		states.slashes:
			parent.animation_player.play("slashes")
		states.recover:
			parent.animation_player.play("recover")
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
		states.jump_antic:
			parent.animation_player.play("antic")
			parent.jump_audio.play()
		states.jump:
			parent.animated_sprite.play("jump")
		states.roar_init:
			parent.animation_player.play("roar init")
		states.scream:
			parent.animated_sprite.play("roar")
		states.roar_antic:
			parent.animation_player.play("roar antic")
		states.roar_recover:
			parent.animation_player.play("roar recover")
		states.evade:
			parent.animated_sprite.play("evade")
	
func _exit_state(old_state, new_state):
	parent.animated_sprite.stop()
	if old_state == states.rest_look_right and new_state == states.rest_look_left:
		parent.animated_sprite.play("rest look right return")
	if old_state == states.rest_look_left and new_state == states.rest_look_right:
		parent.animated_sprite.play("rest look left return")
