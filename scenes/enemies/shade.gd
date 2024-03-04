extends CharacterBody2D

func _ready():
	appear()

func appear():
	$AnimatedSprite2D.play("appear")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("fly")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("idle")
