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
	call_deferred("set_state", states.idle)

func _input(event):
	if Globals.level_preparing:
		return
		
	if [states.idle, states.walk, states.attack, states.look_up, states.look_down].has(state) and parent.is_on_floor():
		if event.is_action_pressed("jump"):
			parent.velocity.y = parent.max_jump_velocity
			parent.jumping = true

	if event.is_action_released("jump") and parent.velocity.y < parent.min_jump_velocity:
		parent.velocity.y = parent.min_jump_velocity
	
	if event.is_action_pressed("attack"):
		if !parent.is_on_floor() and Input.is_action_pressed("down"):
			if parent.can_normal_attack:
				parent.attack_timer.stop()
				parent.down_attacking = true
				parent.can_normal_attack = false
				parent.alt_attacking = false
				parent.attack_timer.start()
				parent.attack_targets()
		elif Input.is_action_pressed("up"):
			if parent.can_normal_attack:
				parent.attack_timer.stop()
				parent.up_attacking = true
				parent.can_normal_attack = false
				parent.alt_attacking = false
				parent.attack_timer.start()
				parent.attack_targets()
		elif parent.can_normal_attack:
			parent.attack_timer.stop()
			parent.normal_attacking = true
			parent.can_normal_attack = false
			parent.alt_attacking = false
			parent.normal_attack_timer.start()
			parent.attack_timer.start()
			parent.attack_targets()
		elif parent.can_alt_attack:
			parent.attack_timer.stop()
			parent.alt_attacking = true
			parent.can_alt_attack = false
			parent.normal_attacking = false
			parent.alt_attack_timer.start()
			parent.attack_timer.start()
			parent.attack_targets()
	
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
	if !Globals.level_preparing:
		parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()
	parent.state_label.text = states.find_key(state)
	
func _get_transition(delta):
	match state:
		states.idle:
			if parent.up_attacking:
				return states.up_attack
			if parent.normal_attacking:
				return states.attack
			if !parent.is_on_floor():
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
			if parent.down_attacking:
				return states.down_attack
			if parent.up_attacking:
				return states.up_attack
			if parent.normal_attacking:
				return states.attack
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.down_attacking:
				return states.down_attack
			if parent.up_attacking:
				return states.up_attack
			if parent.normal_attacking:
				return states.attack
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.down_attacking:
				return states.down_attack
			if parent.up_attacking:
				return states.up_attack
			if parent.normal_attacking:
				return states.attack
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.attack:
			if parent.alt_attacking:
				return states.alt_attack
			if !parent.normal_attacking:
				if parent.velocity.y < 0:
					return states.jump
				if parent.velocity.y > 0:
					return states.fall
				if parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.alt_attack:
			if parent.normal_attacking:
				return states.attack
			if !parent.alt_attacking:
				if parent.velocity.y < 0:
					return states.jump
				if parent.velocity.y > 0:
					return states.fall
				if parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.up_attack:
			if !parent.up_attacking:
				if parent.velocity.y < 0:
					return states.jump
				if parent.velocity.y > 0:
					return states.fall
				if parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.down_attack:
			if !parent.down_attacking:
				if parent.velocity.y < 0:
					return states.jump
				if parent.velocity.y > 0:
					return states.fall
				if parent.velocity.x != 0:
					return states.walk
				elif parent.velocity.x == 0:
					return states.idle
		states.look_up:
			if parent.up_attacking:
				return states.up_attack
			if parent.velocity.y < 0:
				return states.jump
			if parent.velocity.y > 0:
					return states.fall
			if parent.velocity.x != 0:
				return states.walk
			if !parent.looking_up:
				return states.idle
		states.look_down:
			if parent.normal_attacking:
				return states.attack
			if parent.velocity.y < 0:
				return states.jump
			if parent.velocity.y > 0:
				return states.fall
			if parent.velocity.x != 0:
				return states.walk
			if !parent.looking_down:
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.knight_animated_sprite.play("idle")
		states.walk:
			parent.knight_animated_sprite.play("walk")
		states.jump:
			parent.knight_animated_sprite.play("jump")
		states.fall:
			parent.knight_animated_sprite.play("fall")
		states.attack:
			parent.knight_animated_sprite.play("slash")
			parent.slash_animated_sprite.position = parent.standard_slash_marker.position
			parent.slash_animated_sprite.show()
			parent.slash_animated_sprite.play("slash effect")
			await parent.slash_animated_sprite.animation_finished
			parent.slash_animated_sprite.hide()
		states.alt_attack:
			parent.knight_animated_sprite.play("slash alt")
			parent.slash_animated_sprite.position = parent.standard_slash_marker.position
			parent.slash_animated_sprite.show()
			parent.slash_animated_sprite.play("slash effect alt")
			await parent.slash_animated_sprite.animation_finished
			parent.slash_animated_sprite.hide()
		states.up_attack:
			parent.knight_animated_sprite.play("slash up")
			parent.slash_animated_sprite.position = parent.standard_slash_marker.position
			parent.slash_animated_sprite.show()
			parent.slash_animated_sprite.play("slash effect up")
			await parent.slash_animated_sprite.animation_finished
			parent.slash_animated_sprite.hide()
		states.down_attack:
			parent.knight_animated_sprite.play("slash down")
			parent.slash_animated_sprite.position = parent.down_slash_marker.position
			parent.slash_animated_sprite.show()
			parent.slash_animated_sprite.play("slash effect down")
			await parent.slash_animated_sprite.animation_finished
			parent.slash_animated_sprite.hide()
		states.look_up:
			parent.knight_animated_sprite.play("look up")
		states.look_down:
			parent.knight_animated_sprite.play("look down")
	
func _exit_state(old_state, new_state):
	pass
