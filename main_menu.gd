extends PanelContainer

@export var play_button : Button
@export var settings_button : Button
@export var credits_button : Button
@export var quit_button : Button
@export var main_container : VBoxContainer
@export var settings_panel : PanelContainer
@export var credits_panel : PanelContainer

func _ready() -> void:
	settings_panel.close_button.pressed.connect(_on_settings_panel_close_button_pressed)
	credits_panel.return_button.pressed.connect(_on_credits_panel_return_button_pressed)

func reset_visibilities() -> void:
	main_container.visible = true
	settings_panel.visible = false
	credits_panel.visible = false

func open_credits() -> void:
	main_container.visible = false
	credits_panel.visible = true

func _on_settings_button_pressed() -> void:
	main_container.visible = false
	settings_panel.visible = true
	settings_panel.init()
func _on_settings_panel_close_button_pressed() -> void:
	reset_visibilities()
func _on_credits_button_pressed() -> void:
	open_credits()
func _on_credits_panel_return_button_pressed() -> void:
	reset_visibilities()
