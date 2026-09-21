extends Camera3D

var cameraSpeed = 4;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var mouseVelocity = Vector2(Input.get_last_mouse_velocity())
	#var mouseX = mouseVelocity.x * 0.001;
	#var mouseY = mouseVelocity.y * 0.001;
	#
	#var angle = mouseVelocity.x * delta;
	#rotate_x(angle);
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative = Vector2(event.relative)
		var dy = -relative.y
		rotate_x(dy*0.002)
