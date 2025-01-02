extends Node

var isFullscreen : bool = false

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
	isFullscreen = true

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Fullscreen")):
		if(isFullscreen):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED, 0)
			isFullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN, 0)
			isFullscreen = true
