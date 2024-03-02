extends CharacterBody2D

var gravity:float = 3848.0
var speed: float = 2 * Globals.UNIT_SIZE
var move_direction: int = 1 

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = -1000.0
var knockback: Vector2 = Vector2.ZERO
var inital_sprite_scale_x: float

@onready var crawlid_animated_sprite: AnimatedSprite2D = $CrawlidAnimatedSprite

func _ready():
	inital_sprite_scale_x = crawlid_animated_sprite.scale.x

func _physics_process(delta):
	crawlid_animated_sprite.scale.x = move_direction * inital_sprite_scale_x
	
	velocity.x = speed * move_direction
	velocity += knockback
	
	if velocity.y < 2000:
		velocity.y += gravity * delta
		
	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 0.6)
	
	if is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		move_direction *= -1
		$RayCast2D.position.x *= -1.0

	crawlid_animated_sprite.play("walk")


func hit(pos):
	var direction = pos.direction_to(global_position)
	var force = Vector2(direction.x * knockback_strength_x, knockback_strength_y)
	
	knockback = force
	print(knockback)
