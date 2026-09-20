extends Button

var buttonState = ""
var switch = 2

func _on_pressed() -> void:
	if buttonState == "off":
		globalvars.buttonAmount += 1
		buttonState = "on"
		icon = load("res://icon.svg")
	elif buttonState == "on":
		globalvars.buttonAmount -= 1
		buttonState = "off"
		icon = load("res://bwaa.png")
	print(globalvars.buttonAmount)

func _ready() -> void:
	print('hi')
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		icon = load("res://bwaa.png")
		buttonState = "off"
	else:
		icon = load("res://icon.svg")
		buttonState = "on"
		globalvars.buttonAmount += 1
		print(globalvars.buttonAmount)
		
	if globalvars.buttonAmount == 6:
		if globalvars.random == 0:
			icon = load("res://bwaa.png")
			buttonState = "off"
			globalvars.buttonAmount -= 1
	
