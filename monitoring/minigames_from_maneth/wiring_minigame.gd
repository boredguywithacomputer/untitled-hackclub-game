extends CanvasLayer

signal completed

# modify to change number and type of colors (6 colors currently)
const WIRE_COLORS: Array[Color] = [
	Color.RED, Color.DARK_ORANGE, Color.YELLOW, Color.SEA_GREEN, Color.AQUAMARINE, Color.HOT_PINK
]

# size and distancing of wire ends
const SQUARE_SIZE := Vector2(48, 48)
const WIRE_WIDTH := 20.0

@onready var wires: Node2D = $Root/Panel/Board/Wires
@onready var left_col: VBoxContainer = $Root/Panel/Board/Left
@onready var right_col: VBoxContainer = $Root/Panel/Board/Right

# variable initialization
var squares: Array[ColorRect] = [] # initial square that dragging started from
var dragging_from: ColorRect = null # the wire following the mouse
var drag_line: Line2D = null
var connected_count := 0

# initialization
func _ready() -> void:
	_build_squares()
	
	#await get_tree().process_frame
	#for sq in squares:
		#print(sq.get_meta("side"), " ", sq.color, " ", sq.get_global_rect())

# create wire objects on left and right
func _build_squares() -> void:
	var left_colors := WIRE_COLORS.duplicate()
	var right_colors := WIRE_COLORS.duplicate()
	left_colors.shuffle()
	right_colors.shuffle()
	
	for c in left_colors:
		left_col.add_child(_make_square(c, &"left"))
	for c in right_colors:
		right_col.add_child(_make_square(c, &"right"))

# create a single square, iterate over this function
func _make_square(color: Color, side: StringName) -> ColorRect:
	var sq := ColorRect.new()
	sq.color = color
	sq.custom_minimum_size = SQUARE_SIZE
	sq.set_meta("side", side)
	sq.set_meta("connected", false)
	sq.gui_input.connect(_on_square_gui_input.bind(sq))
	squares.append(sq)
	return sq
	
# detect clicks on the wire ends on either side of the screen
func _on_square_gui_input(event: InputEvent, square: ColorRect) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if square.get_meta("connected"):
			return
		_start_drag(square)

# handle user dragging the wire around by dynamically updating the wire (redraw it)
func _start_drag(square: ColorRect) -> void:
	dragging_from = square
	drag_line = _make_wire(square.color)
	_update_drag_line(drag_line)

# redraw the floating wire everytime it moves
func _make_wire(color: Color) -> Line2D:
	var line := Line2D.new()
	line.width = WIRE_WIDTH
	line.default_color = color
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.antialiased = true
	wires.add_child(line)
	return line

# general transform and input functions
func _center_of(square: Control) -> Vector2:
	return square.get_global_rect().get_center()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
		return
	
	if dragging_from == null:
		return
	
	if event is InputEventMouseMotion:
		_update_drag_line(drag_line)
	elif event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		_finish_drag()

# feed in mouse input into line update functions
func _update_drag_line(line: Line2D) -> void:
	line.points = PackedVector2Array([
		wires.to_local(_center_of(dragging_from)),
		wires.get_local_mouse_position()
	])

func _square_under_mouse() -> ColorRect:
	for sq in squares:
		if sq.get_global_rect().has_point(sq.get_global_mouse_position()):
			return sq
	return null
	
# when the user stops dragging a wire, detect if it should snap to another wire or be removed
func _finish_drag() -> void:
	var target := _square_under_mouse()
	
	if target != null and _is_valid_match(dragging_from, target):
		_snap(dragging_from, target)
		#print(dragging_from, " connected")
	else:
		drag_line.queue_free()
	
	dragging_from = null
	drag_line = null

# detect if the user matched wires of the right color
func _is_valid_match(a: ColorRect, b: ColorRect) -> bool:
	return a != b \
	and a.get_meta("side") != b.get_meta("side") \
	and a.color == b.color \
	and not b.get_meta("connected")

# snaps from the mouse's target position to the wire end on the other side
func _snap(a: ColorRect, b: ColorRect) -> void:
	drag_line.points = PackedVector2Array([
		wires.to_local(_center_of(a)),
		wires.to_local(_center_of(b))
	])
	a.set_meta("connected", true)
	b.set_meta("connected", true)
	
	connected_count += 1
	if connected_count == WIRE_COLORS.size():
		_on_completed()

# close off functions (win condition)
func _on_completed() -> void:
	completed.emit()
	print("successful completion")
	globalvars.wiresDone = "yes" # marks that the wires are done in the global variable so it knows to go back to the main game
	await get_tree().create_timer(1.6).timeout
	close()
	
func close() -> void:
	get_tree().paused = false
	queue_free()
