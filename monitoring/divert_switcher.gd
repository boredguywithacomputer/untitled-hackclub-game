extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("caramel"): # switches to the power divert minigame if the button is pressed
		print("divert pressed")
		if globalvars.switch4state == "on":
			globalvars.container.add_child(globalvars.power)
			globalvars.maingame.visible = false
			globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
