extends CanvasLayer

signal completed

const LEAF_COUNT := 6
const LEAF_SIZE := Vector2(56, 56)
const SUCTION_RADIUS := 150.0
const MIN_V := 60.0
const MAX_V := 140.0
const ROAM_RECT := Rect2(300, 20, 480, 410)

@export var leaf_texture: Texture2D

@onready var board: Control = $Root/Panel/Board
@onready var port: Control = $Root/Panel/Board/Port
@onready var leaves: Control = $Root/Panel/Board/Leaves

var active_leaves: Array[Control] = []
var dragging: Control = null
var remaining := LEAF_COUNT

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

func _on_leaf_gui_input(event: InputEvent, leaf: Control) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed \
	and dragging == null:
		dragging = leaf
		leaf.move_to_front()

func _process(delta: float) -> void:
	for leaf in active_leaves:
		if leaf == dragging:
			var pos := leaves.get_local_mouse_position()
			leaf.position = p.clamp(Vector2.ZERO, board.size - LEAF_SIZE)
		else:
			_drift(leaf, delta)

func _drift(leaf: Control, delta: float) -> void:
	var vel: Vector2 = leaf.get_meta("vel")
	leaf.position += vel * delta
	leaf.rotation += float(leaf.get_meta("spin")) * delta
	
	var min_p := ROAM_RECT.position
	var max_p := ROAM_RECT.end - LEAF_SIZE
	
	# bounce only when heading outwards
	if (leaf.position.x < min_p.x and vel.x < 0.0) \
	or (leaf.position.x > max_p.x and vel.x > 0.0):
		vel.x = -vel.x
	if (leaf.position.y < min_p.y and vel.y < 0.0) \
	or (leaf.position.y > max_p.y and vel.y > 0.0):
		vel.y = -vel.y
	leaf.set_meta("vel", vel)
	
