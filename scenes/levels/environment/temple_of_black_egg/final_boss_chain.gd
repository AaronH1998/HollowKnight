extends StaticBody2D

signal breaking
signal broke

var health: int = 12
@onready var chain_base: AnimatedSprite2D = $ChainBase
@onready var hitbox: CollisionPolygon2D = $CollisionPolygon2D
@onready var chain1: Sprite2D = $Chain1
@onready var chain2: Sprite2D = $Chain2
@onready var chain3: Sprite2D = $Chain3
@onready var cut_audio: AudioStreamPlayer2D = $Audio/Cut
@onready var break_audio: AudioStreamPlayer2D = $Audio/Break
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func hit(_direction, damage):
	health -= damage
	cut_audio.play()
	Globals.shake_camera(5,5)
	if health < 0:
		break_chain()


func break_chain():
	breaking.emit()
	animation_player.play("break")
	

func break_effect():
	broke.emit()
