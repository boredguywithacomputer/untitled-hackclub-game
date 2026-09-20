extends Button

var buttonState = ""
var switch = 2

func _on_pressed() -> void: # changes the state of the button when clicked based on its current state
	print("hi6!")
	if buttonState == "off":
		globalvars.buttonAmount += 1
		buttonState = "on"
		icon = load("res://on.png")
	elif buttonState == "on":
		globalvars.buttonAmount -= 1
		buttonState = "off"
		icon = load("res://off.png")
	
func _ready() -> void:
	switch = (randi() % 2) # randomly decides whether the button is on or off
	print(switch)
	if switch == 0:
		icon = load("res://off.png")
		buttonState = "off"
	else:
		icon = load("res://on.png")
		buttonState = "on"
		globalvars.buttonAmount += 1
		
	if globalvars.buttonAmount == 6: # if no buttons are off, pulls from a global var that picks a random number 0-5 corresponding to a button
		if globalvars.random == 5:
			icon = load("res://off.png")
			buttonState = "off"
			globalvars.buttonAmount -= 1
	
