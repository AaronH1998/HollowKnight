extends CharacterBody2D

var gravity:float = 200.0
var speed: float = 100.0
var move_direction: int = 1 

func _physics_process(delta):
	velocity.x = speed * move_direction
	var a=1
	if velocity.y < 2000:
		velocity.y += gravity * delta
	move_and_slide()
	
	if is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		move_direction *= -1
		$RayCast2D.position.x *= -1.0
