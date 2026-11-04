extends Container

@export var play_button : Button
@export var confirm_play_button : Button
@export var back_button : Button
@export var headstart_button : Button
@export var settings_button : Button
@export var credits_button : Button
@export var quit_button : Button
@export var main_container : VBoxContainer
@export var play_container : PanelContainer
@export var settings_panel : PanelContainer
@export var credits_panel : PanelContainer
#Temporary
@export var demo_label : Label
@export var demo_label_player : AnimationPlayer

func _ready() -> void:
	settings_panel.close_button.pressed.connect(_on_settings_panel_close_button_pressed)
	credits_panel.return_button.pressed.connect(_on_credits_panel_return_button_pressed)
	
	if SaveManager.load_file()["best_waves_survived"] < 20:
		headstart_button.disabled = true
	else:
		headstart_button.disabled = false
	#Save your previous headstart setting
	headstart_button.set_pressed_no_signal(Settings.get_headstart_enabled())
	
	#Ugly because temporary
	demo_label_player.play("flash")

func reset_visibilities() -> void:
	main_container.visible = true
	settings_panel.visible = false
	credits_panel.visible = false

func open_credits() -> void:
	main_container.visible = false
	credits_panel.visible = true


func _on_play_button_pressed() -> void:
	main_container.visible = false
	play_container.visible = true
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


func _on_back_button_pressed() -> void:
	main_container.visible = true
	play_container.visible = false


func _on_headstart_button_toggled(toggled_on: bool) -> void:
	Settings.set_headstart_enabled(toggled_on)
