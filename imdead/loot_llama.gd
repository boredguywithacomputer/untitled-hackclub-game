extends RigidBody3D

@export var promptName: String 
@export var triggeredEvent: String

func _ready() -> void:
	$Hitbox.body_entered.connect(_proximity_trigger)
	$Hitbox.body_exited.connect(_deproximity_trigger)

func _proximity_trigger(body: Node3D) -> void:
	if !body.name == "Player": return
	print("player within range")
	Events.prompt.emit(promptName, self, triggeredEvent)
	
func _deproximity_trigger(body: Node3D) -> void:
	if !body.name == "Player": return
	Events.unprompt.emit(self)
