extends CharacterBody3D

var SPEED = 5.0
var JUMP_VELOCITY = 5.0

func _ready() -> void:
	Events.slow.connect(_change_speed)

func _change_speed(speed):
	SPEED += speed

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relative = Vector2(event.relative)
		var dx = -relative.x
		
		rotate_y(dx*0.002)
