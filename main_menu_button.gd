extends CustomButton

func _ready() -> void:
	super()
	
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	super()
	set("theme_override_colors/font_outline_color", Color.BLACK)
func _on_mouse_exited() -> void:
	set("theme_override_colors/font_outline_color", Color.WHITE)
