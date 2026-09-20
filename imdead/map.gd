extends Node

var itemobject = preload("res://gameitems/fuel.tscn")

var wall = preload("res://gameitems/wall.tscn")

var mapwidth = 15

func _spawner() -> void:
	for i in range(6):
		var spawned = itemobject.instantiate()
		get_tree().current_scene.add_child(spawned)
		spawned.global_position = Vector3(randf_range(-mapwidth, mapwidth), 2, randf_range(-mapwidth, mapwidth))

#func _wall_spawner() -> void:
	#for i in range(5):
		#var spawned = wall.instantiate()
		#var spawned2 = wall.instantiate()
		#var spawned3 = wall.instantiate()
		#var spawned4 = wall.instantiate()
		#get_tree().current_scene.add_child(spawned)
		#get_tree().current_scene.add_child(spawned2)
		#get_tree().current_scene.add_child(spawned3)
		#get_tree().current_scene.add_child(spawned4)
		#spawned.global_position = Vector3(6*i, 0.5, 6*i)
		#spawned2.global_position = Vector3(6*i, 0.5, -6*i)
		#spawned3.global_position = Vector3(-6*i, 0.5, -6*i)
		#spawned4.global_position = Vector3(-6*i, 0.5, 6*i)

func _ready() -> void:
	_spawner()
	#_wall_spawner()
	## note: the wall_spawner function was created at 1 am when I was TWEAKING like crazy due to sleep debt accumulated throughout the week
