# Hollow Knight in Godot

## Demos - OUTDATED

### Gameplay


https://github.com/AaronH1998/HollowKnight/assets/53660334/1f329510-2e9d-46a5-9ca6-a232335764f1


### UI and Menus


https://github.com/AaronH1998/HollowKnight/assets/53660334/1e42a820-c1a3-4e56-8b5a-f02f59e065b5


## Current features:
	
### The Knight

* Basic movement
* Basic Nail Attacks
* Camera:
	* Soft follow camera
	* Look up
	* Look down
	* Camera restricted zones.
* Hit:
	* Takes damage when enemies enter player's enemy detection area.
	* Hitstop (brief moment of time slow to accentuate damage)
	* Knockback
* Death:
	* Stops moving and plays death animation
	* Throws out mask and spawns non-functional shade
* Action Sound Effects
* Soul gained via attacks
* Can heal with soul

### The Enemies

* Can be hit
* Dies when 0 zero health
* Can damage player
* Crawlid:
	* Walk in direction until reaches wall or cliff, then turn.
* Vengefly:
	* Fly towards player if in range and recalculate direction on timer.
	* On Death Apply gravity and stop moving
* The Hollow Knight:
	* Slashes, dash and teleport attacks (Phase 1)
	* Win game upon death

### UI

* Main menu:
	* Start Menu with 4 save profiles which can be created, loaded or deleted
	* Audio Menu for 3 different buses which save settings to local cache
* Game:
	* Soul meter
	* Health Indicators
	* Geo Count
* Pause Menu:
	* Pauses scene
	* Resume button to unpause
	* Quit to main menu button
	* Audio menu button
* Game Complete when defeating the hollow knight

### Levels:
* Parallax Background (different layers moving and different speeds)
* Obstacles - Floors, ceilings.
* Enemies
* Player
* Light
* Background Music
* Killbox to prevent out of bounds
* Occlusion Layers to hide areas behind doors
* Transition Layers to enter other levels
* Player is restricted at start of level for X amount of time.
* Level transitions fade in and out of black

### Game persistence:
* 4 save game files.
* Save upon exit.
* Saves:
	* Geo count
