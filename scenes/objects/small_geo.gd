extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_detection_box: CollisionShape2D = $PlayerDetectionArea/CollisionShape2D 
@onready var pickup_audio: AudioStreamPlayer2D = $Audio/Pickup
func _process(_delta):
	if $RayCast2D.is_colliding():
		animated_sprite.play("idle")
	else:
		animated_sprite.play("air")


func _on_area_2d_body_entered(_body):
	pickup_audio.play()
	hide()
	player_detection_box.set_deferred("disabled", true)
	Globals.geo += 1
	await pickup_audio.finished
	queue_free()
	
