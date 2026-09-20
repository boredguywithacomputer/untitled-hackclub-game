extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
##

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _ready():
	main_buttons.visible = true
	options.visible = false


func _on_start_pressed() -> void:
	print("started")
	get_tree().change_scene_to_file("res://node_3d.tscn") #switches to maingame if start pressed


func _on_exit_pressed() -> void:
	print("exitteddd")
	get_tree().quit() #quits if exit pressed


func _on_settings_pressed() -> void:
	print("settings opened") # opens settings menu if settings pressed
	main_buttons.visible = false
	options.visible = true


func _on_back_options_pressed() -> void:
	_ready()
