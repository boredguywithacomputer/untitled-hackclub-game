extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globalvars.container = self # this exists to hold minigames when they run so the original game can stay running


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
