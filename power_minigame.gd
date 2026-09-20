extends CanvasLayer

signal completed

# variable initialization

const SLIDER_COUNT := 8
const SLIDER_SIZE := Vector2(56, 280)
const LIGHT_SIZE := 32.0 # diameter of each light
const START_MIN := 0.15
const START_MAX := 0.85
const COLOR_ON := Color(1.0, 0.45, 0.45)
const COLOR_OFF := Color(0.35, 0.05, 0.05)
const COLOR_DONE := Color(0.2, 0.9, 0.35)
const GRABBER_SIZE = Vector2i(36, 28)

# slider styling

var grabber_tex: ImageTexture
var grabber_hover_tex: ImageTexture
var grabber_off_tex: ImageTexture

func _solid_texture(size: Vector2i, color: Color) -> ImageTexture:
	var img := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(color)
	return ImageTexture.create_from_image(img)
	
func _style_slider(s: VSlider) -> void:
	var track := StyleBoxFlat.new()
	track.bg_color = Color(0.12, 0.13, 0.16)
	track.set_corner_radius_all(4)
	track.content_margin_left = 8
	track.content_margin_right = 8
	s.add_theme_stylebox_override("slider", track)
	s.add_theme_stylebox_override("grabber_area", StyleBoxEmpty.new())
	s.add_theme_stylebox_override("grabber_area_highlight", StyleBoxEmpty.new())
	s.add_theme_icon_override("grabber", grabber_tex)
	s.add_theme_icon_override("grabber_highlight", grabber_hover_tex)
	s.add_theme_icon_override("grabber_disabled", grabber_off_tex)

class Lane:
	var slider: VSlider
	var light_style: StyleBoxFlat
	var move_up: bool
	var done := false

@onready var board: HBoxContainer = $Root/Panel/Board

var lanes: Array[Lane] = []
var done_count := 0

func _ready() -> void:
	grabber_tex = _solid_texture(GRABBER_SIZE, Color(0.85, 0.87, 0.9))
	grabber_hover_tex = _solid_texture(GRABBER_SIZE, Color.WHITE)
	grabber_off_tex = _solid_texture(GRABBER_SIZE, Color(0.45, 0.47, 0.5))
	
	var directions: Array[bool] = []
	for i in SLIDER_COUNT:
		directions.append(randf() < 0.5) # some of them go up, some of them go down
	directions.shuffle()
	
	for move_up in directions:
		lanes.append(_make_lane(move_up))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()

func _make_lane(move_up: bool) -> Lane:
	var lane := Lane.new()
	lane.move_up = move_up
	
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 16)
	board.add_child(box)
	
	# indicator light and lane styling
	lane.light_style = StyleBoxFlat.new()
	lane.light_style.set_corner_radius_all(int(LIGHT_SIZE / 2.0))
	lane.light_style.bg_color = COLOR_ON if move_up else COLOR_OFF
	
	var light := Panel.new()
	light.custom_minimum_size = Vector2(LIGHT_SIZE, LIGHT_SIZE)
	light.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	light.add_theme_stylebox_override("panel", lane.light_style)
	box.add_child(light)
	
	# slider parameters
	var s := VSlider.new()
	_style_slider(s)
	s.min_value = 0.0
	s.max_value = 1.0
	s.step = 0.001
	s.scrollable = false
	s.custom_minimum_size = SLIDER_SIZE
	s.value = randf_range(START_MIN, START_MAX)
	s.value_changed.connect(_on_slider_changed.bind(lane))
	box.add_child(s)
	lane.slider = s
	
	return lane

func _on_slider_changed(value: float, lane: Lane) -> void:
	if lane.done:
		return
		
	var top := is_equal_approx(value, lane.slider.max_value)
	var bottom := is_equal_approx(value, lane.slider.min_value)
	
	if (lane.move_up and top) or (not lane.move_up and bottom):
		_lock_in(lane)
	# otherwise nothing happens if the slider is at the wrong end or in between

# i need to LOCK IN and finish these hours
func _lock_in(lane: Lane) -> void:
	lane.done = true
	lane.slider.editable = false # can't be moved once it's green
	lane.light_style.bg_color = COLOR_DONE
	
	done_count += 1 # is a counter the most efficient way to do this? idk
	if done_count == SLIDER_COUNT:
		_on_completed()

func _on_completed() -> void:
	completed.emit()
	print("successful completion")
	await get_tree().create_timer(1.6).timeout
	close()
	
func close() -> void:
	get_tree().paused = false
	queue_free()
