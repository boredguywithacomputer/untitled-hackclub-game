extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # returns the player to the 3D map once the leaves minigame is done
	if globalvars.filterDone == "yes":
		globalvars.container.remove_child(globalvars.filter)
		globalvars.maingame.visible = true
		globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
		globalvars.switch3state = "off"
		globalvars.score += 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
