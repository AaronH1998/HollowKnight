extends Node2D

var shade_scene: PackedScene = preload("res://scenes/enemies/shade.tscn")
var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")

@onready var enemies: Node2D = $Enemies

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


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
