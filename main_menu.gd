extends PanelContainer

@export var play_button : Button
@export var settings_button : Button
@export var credits_button : Button
@export var quit_button : Button
@export var settings_panel : PanelContainer

func _ready() -> void:
	settings_panel.close_button.pressed.connect(_on_settings_panel_close_button_pressed)

func _on_settings_button_pressed() -> void:
	$VBoxContainer.visible = false
	settings_panel.visible = true
	settings_panel.init()
func _on_settings_panel_close_button_pressed() -> void:
	$VBoxContainer.visible = true
	settings_panel.visible = false
