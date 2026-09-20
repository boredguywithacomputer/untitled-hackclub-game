extends Button

var buttonState = ""
var switch = 2

func _on_pressed() -> void:
	if buttonState == "off":
		globalvars.buttonAmount += 1
		buttonState = "on"
		icon = load("res://on.png")
	elif buttonState == "on":
		globalvars.buttonAmount -= 1
		buttonState = "off"
		icon = load("res://off.png")
	print(globalvars.buttonAmount)

func _ready() -> void:
	print('hi')
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		icon = load("res://off.png")
		buttonState = "off"
	else:
		icon = load("res://on.png")
		buttonState = "on"
		globalvars.buttonAmount += 1
		print(globalvars.buttonAmount)
		
	if globalvars.buttonAmount == 6:
		if globalvars.random == 0:
			icon = load("res://off.png")
			buttonState = "off"
			globalvars.buttonAmount -= 1
	
