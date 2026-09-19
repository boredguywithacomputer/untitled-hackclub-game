extends CanvasLayer

var topobject;
var topprompt = "";
var toptriggerevent;

func _ready() -> void:
	Events.prompt.connect(_displayprompt)
	Events.unprompt.connect(_undisplayprompt)

func _displayprompt(promptname: String, object: Node, triggerevent: String) -> void:
	$InteractPrompt.visible = true
	topprompt = promptname
	topobject = object
	toptriggerevent = triggerevent

func _undisplayprompt(object: Node) -> void:
	if object == topobject:
		$InteractPrompt.visible = false
		topobject = null
		toptriggerevent = null
		topprompt = ""
		
func _process(delta: float) -> void:
	$InteractPrompt.text = "E | " + topprompt
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and topobject and toptriggerevent:
		print("interaction event: " + toptriggerevent)
		Events.interaction.emit(topobject, toptriggerevent)
