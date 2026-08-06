extends Button

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	pressed.connect(_on_pressed)

func _on_mouse_entered() -> void:
	if not disabled:
		AudioManager.button_hover_sfx.play()
func _on_pressed() -> void:
	AudioManager.button_pressed_sfx.play()
