extends PanelContainer

@export var fullscreen_button : Button
@export var close_button : Button

func init() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		fullscreen_button.set_pressed_no_signal(false)
		print_debug("reached a")
	else:
		fullscreen_button.set_pressed_no_signal(true)


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
