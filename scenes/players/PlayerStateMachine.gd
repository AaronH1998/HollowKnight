extends StateMachine

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	add_state("alt_attack")
	add_state("up_attack")
	add_state("down_attack")
	add_state("look_up")
	add_state("look_down")
	add_state("damaged")
	add_state("dead")
	add_state("focus")
	add_state("healing")
	call_deferred("set_state", states.idle)

func _input(event):
	if !parent.is_multiplayer_authority():
		return
		
	if Globals.level_preparing or parent.dead:
		return
	
	if [states.idle, states.walk, states.attack, states.look_up, states.look_down].has(state) and parent.is_on_floor():
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump_velocity
			parent.jumping = true
	
	if event.is_action_released("jump") and parent.velocity.y < parent.min_jump_velocity:
		parent.velocity.y = parent.min_jump_velocity
	
	if event.is_action_pressed("attack") and parent.can_attack:
		if !parent.is_on_floor() and Input.is_action_pressed("down") and state != states.down_attack:
			parent.can_attack = false
			parent.down_attacking = true
			parent.up_attacking = true
			parent.alt_attacking = false
			parent.normal_attacking = false
		elif Input.is_action_pressed("up") and state != states.up_attack:
			parent.can_attack = false
			parent.up_attacking = true
			parent.alt_attacking = false
			parent.normal_attacking = false
			parent.down_attacking = false
		elif state != states.attack and parent.normal_attack_mode:
			parent.can_attack = false
			parent.alt_attacking = false
			parent.normal_attacking = true
			parent.up_attacking = false
			parent.down_attacking = false
		elif state != states.alt_attack and !parent.normal_attack_mode:
			parent.can_attack = false
			parent.normal_attacking = false
			parent.alt_attacking = true
			parent.down_attacking = false
			parent.up_attacking = false
	
	if event.is_action_pressed("cast") and Globals.player_soul >= parent.cast_soul and Globals.player_health < Globals.max_health and [states.idle, states.walk].has(state):
		parent.focussing = true
		parent.is_right_click = true
		
	if event.is_action_released("cast"):
		parent.is_right_click = false
		parent.focussing = false
		
	if event.is_action_pressed("up") and state == states.idle:
		parent.looking_up = true
		parent.look_up_timer.start()
		
	if event.is_action_pressed("down") and state == states.idle:
		parent.looking_down = true
		parent.look_down_timer.start()
	
	if event.is_action_released("up") or not [states.idle, states.look_up].has(state):
		parent.looking_up = false
		parent.look_up_timer.stop()
	
	if event.is_action_released("down") or not [states.idle, states.look_down].has(state):
		parent.looking_down = false
		parent.look_down_timer.stop()
	
	if !parent.looking_up and !parent.looking_down:
		parent.camera_modifier = 0

func _state_logic(delta):
	parent.state_label.text = states.find_key(state)
	if state != states.dead:
		if !Globals.level_preparing and state != states.focus:
			parent._handle_move_input()
		parent._apply_gravity(delta)
		parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.focussing:
				return states.focus
			elif parent.up_attacking:
				return states.up_attack
			elif parent.normal_attacking:
				return states.attack
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.walk
			elif parent.looking_up:
				return states.look_up
			elif parent.looking_down:
				return states.look_down
		states.walk:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.down_attacking:
				return states.down_attack
			elif parent.up_attacking:
				return states.up_attack
			elif parent.normal_attacking:
				return states.attack
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.down_attacking:
				return states.down_attack
			elif parent.up_attacking:
				return states.up_attack
			elif parent.normal_attacking:
				return states.attack
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.down_attacking:
				return states.down_attack
			elif parent.up_attacking:
				return states.up_attack
			elif parent.normal_attacking:
				return states.attack
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.attack:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.alt_attacking:
				return states.alt_attack
			elif !parent.normal_attacking:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.alt_attack:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.normal_attacking:
				return states.attack
			elif !parent.alt_attacking:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.up_attack:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif !parent.up_attacking:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.down_attack:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif !parent.down_attacking:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.look_up:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.up_attacking:
				return states.up_attack
			elif parent.velocity.y < 0:
				return states.jump
			elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.walk
			elif !parent.looking_up:
				return states.idle
		states.look_down:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.normal_attacking:
				return states.attack
			elif parent.velocity.y < 0:
				return states.jump
			elif parent.velocity.y > 0:
				return states.fall
			elif parent.velocity.x != 0:
				return states.walk
			elif !parent.looking_down:
				return states.idle
		states.damaged:
			if parent.dead:
				return states.dead
			elif !parent.damaged:
				if parent.down_attacking:
					return states.down_attack
				elif parent.up_attacking:
					return states.up_attack
				elif parent.normal_attacking:
					return states.attack
				elif parent.is_on_floor():
					return states.idle
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.y < 0:
					return states.jump
		states.focus:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif parent.healing:
				return states.healing
			elif !parent.focussing:
				if parent.down_attacking:
					return states.down_attack
				elif parent.up_attacking:
					return states.up_attack
				elif parent.normal_attacking:
					return states.attack
				elif parent.is_on_floor():
					return states.idle
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.y < 0:
					return states.jump
		states.healing:
			if parent.damaged:
				return states.damaged
			elif parent.dead:
				return states.dead
			elif !parent.healing:
				if parent.focussing:
					return states.focus
				if parent.down_attacking:
					return states.down_attack
				elif parent.up_attacking:
					return states.up_attack
				elif parent.normal_attacking:
					return states.attack
				elif parent.is_on_floor():
					return states.idle
				elif parent.velocity.y > 0:
					return states.fall
				elif parent.velocity.y < 0:
					return states.jump
	return null

func _enter_state(new_state, _old_state):
	# Player animation = sprites in animatedsprite2d played by animationplayer.
	# Animation Player has an fps snap which makes this easier
	# Looped animations need an extra frame to return to the original frame.
	match new_state:
		states.idle:
			parent.action_animation_player.play("idle")
		states.walk:
			parent.action_animation_player.play("walk")
			parent.walk_audio.play()
		states.jump:
			parent.action_animation_player.play("jump")
			parent.jump_audio.play()
		states.fall:
			parent.action_animation_player.play("fall")
		states.attack:
			parent.action_animation_player.play("attack")
			parent.attack_normal_audio.play()
		states.alt_attack:
			parent.action_animation_player.play("attack alt")
			parent.attack_alt_audio.play()
		states.up_attack:
			parent.action_animation_player.play("attack up")
			parent.attack_up_audio.play()
		states.down_attack:
			parent.action_animation_player.play("attack down")
			parent.attack_down_audio.play()
		states.look_up:
			parent.action_animation_player.play("look up")
		states.look_down:
			parent.action_animation_player.play("look down")
		states.damaged:
			parent.damage_audio.play()
			parent.action_animation_player.play("recoil")
			parent.secondary_animation_player.play("invulnerable")
		states.dead:
			parent.action_animation_player.play("death")
			parent.death_audio.play()
		states.focus:
			parent.action_animation_player.play("focus")
			parent.focus_health_charge_audio.play()
		states.healing:
			parent.action_animation_player.play("focus get once")
	
func _exit_state(old_state, new_state):
	parent.action_animation_player.stop()
	parent.walk_audio.stop()
	parent.fall_audio.stop()
	parent.focus_health_charge_audio.stop()
	
	# Set focus to false if interrupted
	if(old_state == states.focus):
		parent.focussing = false
	
	# Set healing to false if interrupted
	if(old_state == states.healing):
		parent.healing = false
		
	#Play land audio when you land
	if(old_state == states.fall and new_state == states.idle):
		parent.land_audio.play()
