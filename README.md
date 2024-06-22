# This is a recreation of Hollow Knight in Godot

## Current features:
	
### The Knight

* Basic movement:
	* Walk
	* Jump
	* Fall
* Attacks:
	* Normal and alt side attacks
	* Up Attack
	* Down Attack with bounce
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
* Sound Effects:
	* Sound effects for actions
* Soul and Heal:
	* Player can gain soul by attacking enemies
	* Player can use soul to heal self

### The Enemies

* Hit:
	* Takes damage when attacked by knight
* Death:
	* Stops moving
	* Plays death animation
	* Becomes uncollidable by player
* Damage:
	* Has collision boxes that collide with player's enemy detection area.
	* Knockback
* Crawlid:
	* Movement:
		* Walk in direction until reaches wall or cliff, then turn.
* Vengefly
	* Movement:
		* Fly towards player if in range
		* Recalculate directin on timer.
	* Death:
		* Apply gravity and stop moving

### UI

* Start Menu:
	* Hollow knight Main Menu music.
	* Play and Exit button.
* Game:
	* Soul meter
	* Health Indicators
* Game Complete:
	* When enemy is defeated, game will complete, show thank you message and return to main menu.
		
### Levels:
* 1 Level
* Levels Contain:
	* Parallax Background (different layers moving and different speeds)
	* Obstacles - Floors, ceilings.
	* Enemies
	* Player
	* Light
	* Background Music
* Start Timer:
	* Player is restricted at start of level for X amount of time.
* Fades:
	* Level transitions fade in and out of black
