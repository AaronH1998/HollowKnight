extends Level

var broken_chains: int = 0

@onready var hollow_knight: CharacterBody2D = $Enemies/HollowKnight
@onready var music: AudioStreamPlayer = $AudioStreamPlayer
@onready var break_free_timer: Timer = $Timers/BreakFreeTimer

const suspence_2: Resource = preload("res://assets/music/thk/Hollow Knight pre-fight - S61-161 Suspence 2.wav")
const suspence_3: Resource = preload("res://assets/music/thk/Hollow Knight pre-fight - S61-161 Suspence 3.wav")
const suspence_4: Resource = preload("res://assets/music/thk/Hollow Knight pre-fight - S61-161 Suspence 4.wav")
const suspence_5: Resource = preload("res://assets/music/thk/Hollow Knight pre-fight - S61-161 Suspence 5.wav")

const phase_1_2 = preload("res://assets/music/thk/Sealed Vessel phase 1+2 - S61-216 Hollow Knight.wav")


func _ready():
	super()
	#hollow_knight.start_break_free()


func _on_level_one_transition_area_body_entered(_body):
	TransitionLayer.change_scene("res://scenes/levels/level_one.tscn")


func _on_hollow_knight_death(_pos, _dir, _geo):
	TransitionLayer.change_scene("res://scenes/menus/game_complete.tscn")


func _on_final_boss_chain_broke():
	if broken_chains == 4:
		Globals.shake_camera(20, 0.8)
	else:
		Globals.shake_camera(10,5)


func _on_break_free_timer_timeout():
	hollow_knight.start_break_free()


func _on_hollow_knight_start_fight():
	music.stream = phase_1_2
	music.play()


func _on_final_boss_chain_breaking():
	broken_chains += 1
	if broken_chains == 1:
		music.stream = suspence_2
		music.play()
	if broken_chains == 2:
		music.stream = suspence_3
		music.play()
	if broken_chains == 3:
		music.stream = suspence_4
		music.play()
	if broken_chains == 4:
		music.stream = suspence_5
		music.play()
		break_free_timer.start()


func _on_hollow_knight_break_chains():
	$Forebackground/SuspensionChains.visible = false
