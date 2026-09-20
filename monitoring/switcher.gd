extends MeshInstance3D



func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



 
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("caramel"):
		print("pressed")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().root.add_child(globalvars.shields)
		globalvars.mainparent = globalvars.maingame.get_parent()
		globalvars.mainparent.remove_child.call_deferred(globalvars.maingame)
