extends MeshInstance3D



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



 
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("caramel"):
		if globalvars.switch1state == "on": # switches to the shields minigame if the cube is touched by the player
			globalvars.container.add_child(globalvars.shields)
			globalvars.maingame.visible = false
			globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
