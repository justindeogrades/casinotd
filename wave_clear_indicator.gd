extends Control

@export var enter_player : AnimationPlayer
@export var flash_player : AnimationPlayer
@export var particles : GPUParticles2D

var col_a : Color = Color.from_rgba8(255, 235, 87)
var col_b : Color = Color.from_rgba8(219, 63, 253)

func _ready() -> void:
	set_z_index(G.SPLASH_TEXT_Z)

func play_wave_clear_sound() -> void:
	AudioManager.set_music_low_pass_enabled(true)
	AudioManager.wave_clear_sfx.play()

func start() -> void:
	enter_player.play("enter")
	flash_player.play("flash")
func end() -> void:
	AudioManager.set_music_low_pass_enabled(false)
