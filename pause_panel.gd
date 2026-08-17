extends PanelContainer

@export var main_container : Container
@export var settings_container : Container
@export var confirm_quit_container : Container

@export var resume_button : Button
@export var settings_button : Button
@export var quit_button : Button

signal quit_confirmed

func _ready() -> void:
	settings_container.close_button.pressed.connect(_on_close_button_pressed)

func _unhandled_input(event: InputEvent) -> void:
	#print_debug("checking")
	
	if Input.is_action_just_pressed("pause"):
		if not visible:
			reset()
			pause()
		else:
			unpause()

func reset() -> void:
	main_container.visible = true
	settings_container.visible = false
	confirm_quit_container.visible = false

func pause() -> void:
	AudioManager.set_music_low_pass_enabled(true)
	visible = true
	get_tree().paused = true
func unpause() -> void:
	AudioManager.set_music_low_pass_enabled(false)
	visible = false
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	unpause()


func _on_settings_button_pressed() -> void:
	settings_container.init()
	
	main_container.visible = false
	settings_container.visible = true


func _on_quit_button_pressed() -> void:
	main_container.visible = false
	confirm_quit_container.visible = true

func _on_close_button_pressed() -> void:
	reset()

func _on_yes_button_pressed() -> void:
	unpause()
	quit_confirmed.emit()


func _on_no_button_pressed() -> void:
	reset()
