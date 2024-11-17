extends StaticBody2D

signal broke

var health: int = 12
@onready var chain_base: AnimatedSprite2D = $ChainBase
@onready var hitbox: CollisionPolygon2D = $CollisionPolygon2D
@onready var chain1: Sprite2D = $Chain1
@onready var chain2: Sprite2D = $Chain2
@onready var chain3: Sprite2D = $Chain3
@onready var cut_audio: AudioStreamPlayer2D = $Audio/Cut
@onready var break_audio: AudioStreamPlayer2D = $Audio/Break

func hit(_direction, damage):
	health -= damage
	cut_audio.play()
	Globals.shake_camera(5,5)
	if health < 0:
		break_chain()

func break_chain():
	chain_base.play("break")
	hitbox.set_deferred("disabled", true)
	chain1.visible = false
	chain2.visible = false
	chain3.visible = false
	break_audio.play()
	broke.emit()
