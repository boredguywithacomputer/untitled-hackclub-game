extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("try again")
	get_tree().change_scene_to_file("res://node_3d.tscn") # restarts main game state if try again is pressed
	globalvars.score = 0
	globalvars.buttonAmount = 0
	globalvars.switch1state = "on"
	globalvars.switch2state = "on"
	globalvars.switch3state = "on"
	globalvars.switch4state = "on"
	globalvars.switch5state = "on"
