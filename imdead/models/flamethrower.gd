extends Node3D

var active = false

func _ready() -> void:
	visible = false
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Inventory.inventory.has("Flamethrower"):
		visible = true
		active = true

func _check_fuel() -> int:
	if Inventory.inventory.has("Fuel"):
		return  Inventory.inventory["Fuel"].count
	else:
		return 0
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire") and active and _check_fuel() > 0:
		Inventory.inventory["Fuel"].count -= 1;
		var colliders = $Hitbox.get_overlapping_bodies()
		Events.burn.emit(colliders)
