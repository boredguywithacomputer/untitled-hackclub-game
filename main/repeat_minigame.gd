extends CanvasLayer

signal completed

# variable initialization
const CELL_COUNT := 9
const CELL_SIZE := Vector2(64, 64)
const SEQUENCE_LENGTH := 5 # keep this around 5 bro ts too hard :(
const FLASH_ON := 0.5 # the timing for flashes during the sequence display
const FLASH_OFF := 0.5
const START_DELAY := 0.8
const INPUT_TIME := 12.0 # how long the player has to input their sequence before the game times out
const FAIL_FLASHES := 3 # how many times the panel flashes when you fail
const FAIL_FLASH_TIME := 0.25
const COLOR_OFF := Color(0.35, 0.05, 0.05) # all of the light colors
const COLOR_ON := Color(1.0, 0.2, 0.2)

enum State { SHOWING, ENTERING, FAILED, DONE }

@onready var button_grid: GridContainer = $Root/Panel/Board/InputPanel/ButtonGrid
@onready var light_grid: GridContainer = $Root/Panel/Board/OutputPanel/LightGrid

var state := State.SHOWING
var sequence: Array[int] = []
var input_index := 0
var time_left := 0.0
var buttons: Array[Button] = []
var lights: Array[ColorRect] = []

# initialization functions, self explanatory
func _ready() -> void:
	for i in CELL_COUNT:
		lights.append(_make_light())
		buttons.append(_make_button(i))
	_start_round()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()

func _make_light() -> ColorRect:
	var light := ColorRect.new()
	light.custom_minimum_size = CELL_SIZE
	light.color = COLOR_OFF
	light_grid.add_child(light)
	return light

func _make_button(index: int) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = CELL_SIZE
	btn.focus_mode = Control.FOCUS_NONE # no space/enter input
	btn.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS # register on initial press, not release
	_style_button(btn)
	btn.pressed.connect(_on_button_pressed.bind(index))
	button_grid.add_child(btn)
	return btn

# button styling, set colors, tweak corner radii, override stylebox
func _style_button(btn: Button) -> void:
	var colors := { # all of the button colors (shades of gray)
		"normal": Color(0.55, 0.55, 0.58),
		"hover": Color(0.68, 0.68, 0.72),
		"pressed": Color(0.85, 0.85, 0.9),
		"disabled": Color(0.4, 0.4, 0.42)
	}
	for style_name in colors:
		var sb := StyleBoxFlat.new()
		sb.bg_color = colors[style_name]
		sb.set_corner_radius_all(6)
		btn.add_theme_stylebox_override(style_name, sb)

# intialization function, basically starts the light sequence
func _start_round() -> void:
	state = State.SHOWING
	_set_buttons_enabled(false)
	
	sequence.clear()
	for i in SEQUENCE_LENGTH:
		sequence.append(randi_range(0, CELL_COUNT - 1))
	#print(sequence)
	
	var tw := create_tween()
	tw.tween_interval(START_DELAY)
	for idx in sequence:
		tw.tween_callback(_set_light.bind(idx, true))
		tw.tween_interval(FLASH_ON)
		tw.tween_callback(_set_light.bind(idx, false))
		tw.tween_interval(FLASH_OFF)
	tw.tween_callback(_begin_input)

# once the light sequence is over, opens up input to the player
func _begin_input() -> void:
	state = State.ENTERING
	input_index = 0
	time_left = INPUT_TIME
	_set_buttons_enabled(true)

# modular light/button setting functions
func _set_light(index: int, on: bool) -> void:
	lights[index].color = COLOR_ON if on else COLOR_OFF
	
func _set_all_lights(on: bool) -> void:
	for i in CELL_COUNT:
		_set_light(i, on)

func _set_buttons_enabled(enabled: bool) -> void:
	for b in buttons:
		b.disabled = not enabled

func _on_button_pressed(index: int) -> void:
	if state != State.ENTERING:
		return
	
	if index != sequence[input_index]:
		_fail()
		return
	# otherwise, the player pressed the correct button so continue the sequence
	input_index += 1
	if input_index == sequence.size():
		_win()

# main process of player input, along with a timer to time out if player takes too long
func _process(delta: float) -> void:
	if state != State.ENTERING:
		return
	time_left -= delta
	if time_left <= 0.0:
		_fail()

# if the player times out or enters the wrong sequence
func _fail() -> void:
	state = State.FAILED
	_set_buttons_enabled(false)
	
	var tw := create_tween()
	for i in FAIL_FLASHES:
		tw.tween_callback(_set_all_lights.bind(true))
		tw.tween_interval(FAIL_FLASH_TIME)
		tw.tween_callback(_set_all_lights.bind(false))
		tw.tween_interval(FAIL_FLASH_TIME)
	tw.tween_callback(_start_round)

# close off functions (win condition)
func _win() -> void:
	state = State.DONE
	_set_buttons_enabled(false)
	completed.emit()
	
	var tw := create_tween()
	tw.tween_interval(0.6)
	tw.tween_callback(close)

	print("successful completion")
	await get_tree().create_timer(1.0).timeout
	close()
	
func close() -> void:
	get_tree().paused = false
	queue_free()
	
