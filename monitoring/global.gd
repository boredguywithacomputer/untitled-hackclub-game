extends Node

var buttonAmount = 0
var random = (randi() % 6)
var shields = preload("res://shields.tscn").instantiate()
var maingame = ""
var mainparent = ""
var maininst = ""
var container: Node
var switch1state = "on"
