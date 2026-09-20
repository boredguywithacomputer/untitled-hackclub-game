extends Button

var buttonState = ""
var switch = 0

func _on_pressed() -> void:
	print("hi2!")
	
func _ready() -> void:
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		icon = load("res://bwaa.png")
		buttonState = "off"
	else:
		icon = load("res://icon.svg")
		buttonState = "on"
