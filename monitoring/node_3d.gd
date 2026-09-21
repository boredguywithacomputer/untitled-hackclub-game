extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalvars.maingame = get_node(".") # grabs the node name for the main game state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if globalvars.score == 5:
		globalvars.score = 0
		print("you win!")
