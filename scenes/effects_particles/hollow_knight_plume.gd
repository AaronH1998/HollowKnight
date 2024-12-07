extends Area2D

signal burst

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	animated_sprite.play("antic")
	await animated_sprite.animation_finished
	burst.emit()
	collision_shape.disabled = false
	animated_sprite.play("burst")
	await animated_sprite.animation_finished
	queue_free()

func _on_body_entered(body):
	if "hit" in body:
		body.hit(Vector2.UP, 2)
