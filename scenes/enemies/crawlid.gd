extends CharacterBody2D

signal crawlid_death

var gravity:float = 3848.0
var speed: float = 2 * Globals.UNIT_SIZE
var move_direction: int = 1 

var knockback_strength_x: float = 9000.0
var knockback_strength_y: float = 750.0
var knockback: Vector2 = Vector2.ZERO
var inital_sprite_scale_x: float

var health: int = 2000

var dead: bool = false

@onready var crawlid_animated_sprite: AnimatedSprite2D = $CrawlidAnimatedSprite

func _ready():
	inital_sprite_scale_x = crawlid_animated_sprite.scale.x


func _apply_gravity(delta):
	if velocity.y < 2000:
		velocity.y += gravity * delta


func _apply_movement():
	crawlid_animated_sprite.scale.x = move_direction * inital_sprite_scale_x
	
	velocity.x = speed * move_direction
	velocity += knockback
	
	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 0.6)
	
	if is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		move_direction *= -1
		$RayCast2D.position.x *= -1.0


func hit(direction, damage):
	health -= damage

	var force = Vector2(direction.x * knockback_strength_x, direction.y * knockback_strength_y)
	knockback = force
	
	if(health <= 0):
		_die()


func _die():
	dead = true
	speed = 0
	_disable_player_collision()
	crawlid_death.emit()


func _disable_player_collision():
	set_collision_layer_value(2, false)
	set_collision_layer_value(7, true)
