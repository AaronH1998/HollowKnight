extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var is_jumping = false
var max_jumps = 5
var current_jump = 1

func _input(event):
	if event.is_action_pressed("jump") and current_jump < max_jumps:
		is_jumping = true
		current_jump +=1
		timer.start()
	if event.is_action_released("jump"):
		timer.stop()
		is_jumping = false
		
func _process(_delta):
	if(velocity.y < 0):
		animated_sprite.play("jump")
	else:
		animated_sprite.play("default")

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		current_jump = 1
	else:
		velocity.y += 2403 * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		is_jumping = true
		timer.start()

	if Input.is_action_pressed("jump") and is_jumping:
		velocity.y = JUMP_VELOCITY * (pow(0.8,current_jump - 1))

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout():
	is_jumping = false
