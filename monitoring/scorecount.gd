extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Your Score: %d" % globalvars.score # prints the score onto the loss screen so players can see how close (or far) they were from winning


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
