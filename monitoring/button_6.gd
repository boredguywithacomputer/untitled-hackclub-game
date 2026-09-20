extends Button

var buttonState = ""
var switch = 0

func _on_pressed() -> void:
	print("hi6!")
	
func _ready() -> void:
	switch = (randi() % 2)
	print(switch)
	if switch == 0:
		load("res://bwaa.png")
		buttonState = "off"
	else:
		load("res://icon.svg")
		buttonState = "on"
	
