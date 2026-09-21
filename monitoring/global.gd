extends Node
# woah global variables so cool :0 seen as globalvars.varname in the rest of the code
var buttonAmount = 0 # amount of buttons for the shields minigame that are on yes
var random = (randi() % 6) # random number picked in case all of the shields buttons are on 'on'
var shields = preload("res://shields.tscn").instantiate() # these preload all of the minigames so they're quick to run
var filter = preload("res://minigames_from_maneth/filter_minigame.tscn").instantiate()
var power = preload("res://minigames_from_maneth/power_minigame.tscn").instantiate()
var repeat = preload("res://minigames_from_maneth/repeat_minigame.tscn").instantiate()
var wiring = preload("res://minigames_from_maneth/wiring_minigame.tscn").instantiate()
var wiresDone = "no" # these all turn into "yes" when each minigame's win condition is met
var filterDone = "no"
var powerDone = "no"
var repeatDone = "no"
var maingame = "" # these are filled by different nodes - the main game, the main game's parent, and the container that's used for all of the minigames
var mainparent = ""
var container: Node
var switch1state = "on" # tracks each minigame's button, turns to "off" if the minigame has been completed
var switch2state = "on"
var switch3state = "on"
var switch4state = "on"
var switch5state = "on"
var score = 0 # player score, increments each time that the player successfully finishes a minigame.
