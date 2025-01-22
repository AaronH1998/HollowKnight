extends Level

@onready var behind_door_1_obstruction: Sprite2D = $OcclusionLayer/ParallaxObstruction/ParallaxLayer/BehindDoor1

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene


func _input(event):
	if event.is_action_pressed("host"):
		peer.create_server(135)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		_add_player()
	if event.is_action_pressed("join"):
		peer.create_client("localhost", 135)
		multiplayer.multiplayer_peer = peer

func _on_breakable_door_broken():
	behind_door_1_obstruction.hide()


func _on_cave_camera_lock_body_entered(_body):
	var tween = create_tween()
	tween.tween_property(light, "energy", 3.0, 2.0)


func _on_cave_camera_lock_body_exited(_body):
	var tween = create_tween()
	tween.tween_property(light, "energy", 1.5, 2.0)


func _on_hollow_knight_level_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/level_hollow_knight.tscn")


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	player.global_position = Vector2(0,1)
