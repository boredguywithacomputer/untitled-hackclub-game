extends CharacterBody3D

var player = null

const speed = 2
@export var playerPath: NodePath
@onready var navAgent = $NavigationAgent3D

func _ready() -> void:
	player = get_node(playerPath)

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	navAgent.set_target_position(player.global_position)
	var nextNavPoint = navAgent.get_next_path_position()
	velocity = (nextNavPoint - global_position).normalized() * speed

	move_and_slide()
