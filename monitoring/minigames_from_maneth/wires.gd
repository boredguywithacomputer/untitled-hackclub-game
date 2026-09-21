extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # makes it so the node is always being processed, so you can click on stuff during the minigames

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # sends the player back to the 3D node once the wire minigame is done
	if globalvars.wiresDone == "yes":
		globalvars.container.remove_child(globalvars.wiring)
		globalvars.maingame.visible = true
		globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
		globalvars.switch2state = "off"
		globalvars.score += 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
