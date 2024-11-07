extends StaticBody2D

signal broke

var health: int = 12
@onready var chain_base: AnimatedSprite2D = $ChainBase
@onready var hitbox: CollisionPolygon2D = $CollisionPolygon2D
@onready var chain1: Sprite2D = $Chain1
@onready var chain2: Sprite2D = $Chain2

func hit(_direction, damage):
	health -= damage
	if health < 0:
		chain_base.play("break")
		hitbox.set_deferred("disabled", true)
		chain1.visible = false
		chain2.visible = false
		broke.emit()
