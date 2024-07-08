extends StaticBody2D

signal broken

func hit(_direction, _attack_damage):
	broken.emit()
	queue_free()
