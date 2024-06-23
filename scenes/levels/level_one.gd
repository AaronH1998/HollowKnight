extends Node2D

var shade_scene: PackedScene = preload("res://scenes/enemies/shade.tscn")
var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")
var puff_scene: PackedScene = preload("res://scenes/effects_particles/orange_puff.tscn")

@onready var enemies: Node2D = $Enemies

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.connect("enemy_hit", _on_enemy_hit)


func _process(_delta):
	if enemies.get_child_count() <= 0:
		TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_start_timer_timeout():
	Globals.level_preparing = false


func _on_player_player_death():
	var shade = shade_scene.instantiate() as CharacterBody2D
	shade.position = $Player.position
	
	var death_mask = death_mask_scene.instantiate() as RigidBody2D
	death_mask.position = $Player.position
	
	$Enemies.add_child(shade)
	$Items.add_child(death_mask)
	
	death_mask.apply_force(Vector2(-30000,0), Vector2.LEFT)

	await get_tree().create_timer(1).timeout
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_crawlid_crawlid_death():
	TransitionLayer.change_scene("res://scenes/menus/game_complete.tscn")


func _on_enemy_hit(pos, dir):
	for i in randi_range(3,10):
		var puff = puff_scene.instantiate() as RigidBody2D
		puff.position = pos
		puff.linear_velocity = Vector2(dir.x + randf_range(-0.5,0.5), dir.y + randf_range(-0.5, 0.5))  * puff.speed
		$Effects.call_deferred("add_child", puff)
