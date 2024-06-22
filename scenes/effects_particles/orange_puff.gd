extends RigidBody2D

var speed: int = 400

func _ready():
	$AnimationPlayer.play("puff")
	
