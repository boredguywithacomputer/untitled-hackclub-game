extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #makes it so that info is always being processed so that you can still click on the buttons when it's put inside of the container node
	globalvars.shields = self #pulls the node name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if globalvars.buttonAmount == 6:
		globalvars.buttonAmount = 0 #if all buttons are on, sends back to main game, disables button, and increments score by 1
		print("complete!")
		globalvars.container.remove_child(globalvars.shields)
		globalvars.maingame.visible = true
		globalvars.maingame.set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)
		globalvars.switch1state = "off"
		globalvars.score += 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
