extends ColorRect

func _ready() -> void:
	visible = false
	Events.interaction.connect(_check_for_shop)
	$Button.pressed.connect(_close_button_pressed)

func _get_fish() -> int:
	if Inventory.inventory.has("Fish"):
		return  Inventory.inventory["Fish"].count
	else:
		return 0

func _check_for_shop(object: Object, triggerevent: String) -> void:
	if triggerevent == "Open_Shop":
		$Fishcount.text = "You have " + str(_get_fish()) + " Fish."
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _close_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
