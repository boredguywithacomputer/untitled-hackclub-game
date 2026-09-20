extends Node
# woah global variables so cool :0 seen as globalvars.varname in the rest of the code
var buttonAmount = 0
var random = (randi() % 6)
var shields = preload("res://shields.tscn").instantiate()
var maingame = ""
var mainparent = ""
var maininst = ""
var container: Node
var switch1state = "on"
var score = 0
