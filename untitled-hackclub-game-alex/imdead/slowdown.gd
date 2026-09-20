extends Area3D

var debuff = -3

func _ready() -> void:
	body_entered.connect(_slowdown)
	body_exited.connect(_unslowdown)
	
func _process(delta: float) -> void:
	pass
	
func _slowdown(body: Node3D):
	if !body.name == "Player": return
	Events.slow.emit(debuff)
	print("slowing")

func _unslowdown(body: Node3D):
	if !body.name == "Player": return
	Events.slow.emit(-debuff)
	print("unslowing")
