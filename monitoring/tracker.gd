extends CharacterBody3D

var player = null

const speed = 3.5
@export var playerPath: NodePath
@onready var navAgent = $NavigationAgent3D

func _ready() -> void:
	player = get_node(playerPath)

func _process(_delta: float) -> void:
	velocity = Vector3.ZERO
	var trueSpeed = (globalvars.score + 1) + speed
	navAgent.set_target_position(player.global_position) # follows the player 
	var nextNavPoint = navAgent.get_next_path_position()
	velocity = (nextNavPoint - global_position).normalized() * trueSpeed

	move_and_slide()


func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("caramel"):
		get_tree().change_scene_to_file.call_deferred("res://lose_screen.tscn") # goes to lose screen if the enemy touches the player
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		
