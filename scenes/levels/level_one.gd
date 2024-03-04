extends Node2D

var shade_scene: PackedScene = preload("res://scenes/enemies/shade.tscn")
var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")

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
