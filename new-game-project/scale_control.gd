extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	var options = [1, 0.75, 0.50, 0.25]
	var value = options[index]
	print(value)
	get_tree().root.scaling_3d_scale = value
