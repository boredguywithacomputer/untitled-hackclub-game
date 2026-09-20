extends CanvasLayer

signal completed

# variable initialization
const LEAF_COUNT := 10
const LEAF_SIZE := Vector2(56, 56)
const SUCTION_RADIUS := 150.0 # how close a leaf needs to get to the center of the left side to get sucked in
const MIN_V := 90.0 # speed of the leaves will range between these numbers
const MAX_V := 170.0
const ROAM_RECT := Rect2(200, 20, 800, 610) # bounding box that free floating leaves will be in

@export var leaf_texture: Texture2D

@onready var board: Control = $Root/Panel/Board
@onready var port: Control = $Root/Panel/Board/Port
@onready var leaves: Control = $Root/Panel/Board/Leaves

var active_leaves: Array[Control] = []
var dragging: Control = null
var remaining := LEAF_COUNT

# initialization functions
func _ready() -> void:
	for i in LEAF_COUNT:
		_spawn_leaf()

func _spawn_leaf() -> void:
	var leaf := _make_leaf()
	leaf.position = Vector2(
		randf_range(ROAM_RECT.position.x, ROAM_RECT.end.x - LEAF_SIZE.x),
		randf_range(ROAM_RECT.position.y, ROAM_RECT.end.y - LEAF_SIZE.y)
	)
	leaf.rotation = randf() * TAU
	leaf.set_meta("vel", Vector2.from_angle(randf() * TAU) * randf_range(MIN_V, MAX_V))
	leaf.set_meta("spin", randf_range(-1.5, 1.5))
	leaf.gui_input.connect(_on_leaf_gui_input.bind(leaf))
	leaves.add_child(leaf)
	active_leaves.append(leaf)
	
# render the texture or rectangle placeholder for each leaf
func _make_leaf() -> Control:
	var leaf: Control
	if leaf_texture:
		var tr := TextureRect.new()
		tr.texture = leaf_texture
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stetch_mode = TextureRect.STRETCH_SCALE
		leaf = tr
	else: # placeholder
		var cr := ColorRect.new()
		cr.color = Color(0.3, 0.75, 0.3)
		leaf = cr
	leaf.custom_minimum_size = LEAF_SIZE
	leaf.size = LEAF_SIZE
	leaf.pivot_offset = LEAF_SIZE / 2.0
	leaf.mouse_filter = Control.MOUSE_FILTER_STOP
	return leaf

# detect when the user starts dragging around a leaf
func _on_leaf_gui_input(event: InputEvent, leaf: Control) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed \
	and dragging == null:
		dragging = leaf
		leaf.move_to_front()

# main leaf loop, float around randomly when user is not clicking it
func _process(delta: float) -> void:
	for leaf in active_leaves:
		if leaf == dragging:
			var pos := leaves.get_local_mouse_position()
			leaf.position = pos.clamp(Vector2.ZERO, board.size - LEAF_SIZE)
		else:
			_drift(leaf, delta)

# trajectory calculations for random floating
func _drift(leaf: Control, delta: float) -> void:
	var vel: Vector2 = leaf.get_meta("vel")
	leaf.position += vel * delta
	leaf.rotation += float(leaf.get_meta("spin")) * delta
	
	# minimum and maximum positions on the x, y axes
	var min_pos := ROAM_RECT.position
	var max_pos := ROAM_RECT.end - LEAF_SIZE
	
	# bounce only when heading outwards
	if (leaf.position.x < min_pos.x and vel.x < 0.0) \
	or (leaf.position.x > max_pos.x and vel.x > 0.0):
		vel.x = -vel.x
	if (leaf.position.y < min_pos.y and vel.y < 0.0) \
	or (leaf.position.y > max_pos.y and vel.y > 0.0):
		vel.y = -vel.y
	leaf.set_meta("vel", vel)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
		return
	
	# detect when the user stops dragging the leaf 
	if dragging != null \
	and event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		_release_leaf()

# either let the leaf get sucked in or continue its random trajectory
func _release_leaf() -> void:
	var leaf := dragging
	dragging = null
	if _leaf_center(leaf).distance_to(_port_center()) <= SUCTION_RADIUS:
		_suck_in(leaf)
	# otherwise do nothing and let the _process() function pick it back up

# transform functions for finding the center of objects
func _leaf_center(leaf: Control) -> Vector2:
	return leaf.position + LEAF_SIZE / 2.0

func _port_center() -> Vector2:
	return port.position + port.size / 2.0

# funny animation where it spins and shrinks :3
func _suck_in(leaf: Control) -> void:
	active_leaves.erase(leaf)
	leaf.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var tw := create_tween().set_parallel(true)
	tw.tween_property(leaf, "position", _port_center() - LEAF_SIZE / 2.0, 0.25) \
	.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.tween_property(leaf, "scale", Vector2.ZERO, 0.25)
	tw.tween_property(leaf, "rotation", leaf.rotation + TAU, 0.25)
	tw.finished.connect(_on_leaf_absorbed.bind(leaf))

# counter function effectively
func _on_leaf_absorbed(leaf: Control) -> void:
	leaf.queue_free()
	remaining -= 1
	if remaining == 0:
		_on_completed()

# close off functions (win condition)	
func _on_completed() -> void:
	completed.emit()
	await get_tree().create_timer(1.6).timeout
	print("successful completion")
	close()

func close() -> void:
	get_tree().paused = false
	queue_free()
