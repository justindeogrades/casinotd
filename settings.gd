extends Node

enum damage_indicators {
	ALWAYS,
	ONLY_CRITS,
	NEVER
}

const DEFAULT_FULLSCREEN_ENABLED : bool = true
const DEFAULT_SFX_SLIDER_VALUE : float = 0.8
const DEFAULT_MUSIC_SLIDER_VALUE : float = 0.8
const DEFAULT_DAMAGE_INDICATORS_ENABLED : int = damage_indicators.ALWAYS
const DEFAULT_QUICK_SPINS_ENABLED : bool = false

var damage_indicators_enabled : int = DEFAULT_DAMAGE_INDICATORS_ENABLED
var quick_spins_enabled : bool = DEFAULT_QUICK_SPINS_ENABLED

func set_damage_indicators_enabled(option : int) -> void:
	damage_indicators_enabled = option
func set_quick_spins_enabled(enabled : bool) -> void:
	quick_spins_enabled = enabled
func get_damage_indicators_enabled() -> int:
	return damage_indicators_enabled
func get_quick_spins_enabled() -> bool:
	return quick_spins_enabled
