extends Node
# woah global variables so cool :0 seen as globalvars.varname in the rest of the code
var buttonAmount = 0
var random = (randi() % 6)
var shields = preload("res://shields.tscn").instantiate()
var filter = preload("res://minigames_from_maneth/filter_minigame.tscn").instantiate()
var power = preload("res://minigames_from_maneth/power_minigame.tscn").instantiate()
var repeat = preload("res://minigames_from_maneth/repeat_minigame.tscn").instantiate()
var wiring = preload("res://minigames_from_maneth/wiring_minigame.tscn").instantiate()
var maingame = ""
var mainparent = ""
var maininst = ""
var container: Node
var switch1state = "on"
var switch2state = "on"
var switch3state = "on"
var switch4state = "on"
var switch5state = "on"
var score = 0
