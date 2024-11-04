extends Node2D
class_name Level

var shade_scene: PackedScene = preload("res://scenes/enemies/shade.tscn")
var death_mask_scene: PackedScene = preload("res://scenes/objects/death_mask.tscn")
var puff_scene: PackedScene = preload("res://scenes/effects_particles/orange_puff.tscn")
var small_geo_scene: PackedScene = preload("res://scenes/objects/small_geo.tscn") 

@onready var enemies: Node2D = $Enemies
@onready var light: DirectionalLight2D = $Lights/DirectionalLight2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	Persistence.world_stats.zone = "King's Pass"
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.connect("enemy_hit", _on_enemy_hit)
		enemy.connect("death", _on_enemy_death)


func _on_enemy_hit(pos, dir):
	for i in randi_range(3,10):
		var puff = puff_scene.instantiate() as RigidBody2D
		puff.position = pos
		puff.linear_velocity = Vector2(dir.x + randf_range(-0.5,0.5), dir.y + randf_range(-0.5, 0.5))  * puff.speed
		$Effects.call_deferred("add_child", puff)


func _on_enemy_death(pos, dir, geo):
	for i in range(geo):
		var small_geo_obj = small_geo_scene.instantiate() as RigidBody2D
		small_geo_obj.position = pos
		$Drops.call_deferred("add_child", small_geo_obj)
		small_geo_obj.apply_force(Vector2(dir.x * 100 * randi_range(5,10),0), pos)


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


func _on_kill_box_body_entered(body):
	if "kill" in body:
		body.kill()
