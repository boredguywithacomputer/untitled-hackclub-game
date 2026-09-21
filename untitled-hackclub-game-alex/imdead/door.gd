extends RigidBody3D

func _ready() -> void:
	Events.burn.connect(_check_if_burned)

func _check_if_burned(victims):
	if victims.has(self):
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
