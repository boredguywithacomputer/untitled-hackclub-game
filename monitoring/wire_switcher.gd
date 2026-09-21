extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void: # switches (eventually) to the wiring minigame if the character hits the cube
	if body.is_in_group("caramel"):
		print("wires pressed")
		if globalvars.switch2state == "on":
			call_deferred("wires")
			
func wires() -> void:		
		globalvars.container.add_child(globalvars.wiring)
		globalvars.maingame.visible = false
		globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		print("wiring process mode: ", globalvars.wiring.process_mode)
		print("wiring visible: ", globalvars.wiring.visible)
		print("mouse mode: ", Input.mouse_mode)
		
