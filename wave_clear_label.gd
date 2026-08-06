extends Node

@export var enter_player : AnimationPlayer
@export var flash_player : AnimationPlayer
@export var particles : GPUParticles2D

var col_a : Color = Color.from_rgba8(255, 235, 87)
var col_b : Color = Color.from_rgba8(219, 63, 253)

func play_wave_clear_sound() -> void:
	AudioManager.wave_clear_sfx.play()
