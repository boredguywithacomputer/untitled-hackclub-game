extends Node

var inventoryLabel;
var inventory = {};

func _ready() -> void:
	inventoryLabel = get_node("/root/Node3D/CanvasLayer/Inventory")
	Events.interaction.connect(_check_for_pickups)
	
func _process(delta: float) -> void:
	pass

func _update_inventory_ui():
	var inv = "";
	for item in inventory:
		var count = inventory[item].count
		inv += str(item, ": ", inventory[item].count, "x\n")
	inventoryLabel.text = inv

func _check_for_pickups(object: Node, triggerevent: String) -> void:
	if triggerevent.begins_with("Grab_"):
		var objectname = triggerevent.split("Grab_")[1];
		#object.queue_free()
		if inventory.has(objectname):
			inventory[objectname].count += 1
		else:
			inventory[objectname] = { "count": 1 }
	_update_inventory_ui()
