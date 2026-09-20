extends Button

var buttonState = ""
var switch = 2

func _on_pressed() -> void:
	print("hi2!")
	if buttonState == "off":
		globalvars.buttonAmount += 1
		buttonState = "on"
		icon = load("res://on.png")
	elif buttonState == "on":
		globalvars.buttonAmount -= 1
		buttonState = "off"
		icon = load("res://off.png")
	
func _ready() -> void:
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		icon = load("res://off.png")
		buttonState = "off"
	else:
		icon = load("res://on.png")
		buttonState = "on"
		globalvars.buttonAmount += 1
		
	if globalvars.buttonAmount == 6:
		if globalvars.random == 1:
			icon = load("res://off.png")
			buttonState = "off"
			globalvars.buttonAmount -= 1
