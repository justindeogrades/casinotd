extends PanelContainer

@export var fullscreen_button : Button
@export var close_button : Button
@export var music_slider : HSlider
@export var sfx_slider : HSlider
@export var damage_indicators_button : Button
@export var quick_spins_button : Button

@onready var sfx_bus = AudioServer.get_bus_index("SFX")
@onready var music_bus = AudioServer.get_bus_index("Music")

func init() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		fullscreen_button.set_pressed_no_signal(false)
	else:
		fullscreen_button.set_pressed_no_signal(true)
	
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	
	damage_indicators_button.set_pressed_no_signal(Settings.get_damage_indicators_enabled())
	quick_spins_button.set_pressed_no_signal(Settings.get_quick_spins_enabled())


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))


func _on_show_damage_indicators_button_toggled(toggled_on: bool) -> void:
	Settings.set_damage_indicators_enabled(toggled_on)

func _on_quick_spins_button_toggled(toggled_on: bool) -> void:
	Settings.set_quick_spins_enabled(toggled_on)
