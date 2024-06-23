extends Enemy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_audio: AudioStreamPlayer2D = $Audio/Walk

var crawlid_health = 8

func _ready():
	super()
	health = crawlid_health

func _apply_movement():
	animated_sprite.scale.x = move_direction * inital_sprite_scale_x

	velocity.x = speed * move_direction
	velocity += knockback
	
	move_and_slide()
	
	knockback = lerp(knockback, Vector2.ZERO, 0.6)
	
	if is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		move_direction *= -1
		$RayCast2D.position.x *= -1.0
