extends HSlider

@export var audio_bus_name : String

func _ready():
	var audio_bus_id = AudioServer.get_bus_index(audio_bus_name)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db()
 
