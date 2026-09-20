extends Button

var buttonState = ""
var switch = 2

func _on_pressed() -> void:
	print("hi3!")
	if buttonState == "off":
		globalvars.buttonAmount += 1
		buttonState = "on"
		icon = load("res://icon.svg")
	elif buttonState == "on":
		globalvars.buttonAmount -= 1
		buttonState = "off"
		icon = load("res://bwaa.png")
	
func _ready() -> void:
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		load("res://bwaa.png")
		buttonState = "off"	
	else:
		load("res://icon.svg")
		buttonState = "on"
		globalvars.buttonAmount += 1
		
	if globalvars.buttonAmount == 6:
		if globalvars.random == 2:
			icon = load("res://bwaa.png")
			buttonState = "off"
			globalvars.buttonAmount -= 1
	
