extends Node

@export var damage_indicator_resource : Resource

func create_damage_indicator(amount : int, crit_level : int, pos : Vector2):
	if check_damage_indicator_setting(crit_level):
		var indicator_instance = damage_indicator_resource.instantiate()
		indicator_instance.init(amount, crit_level, pos)
		add_child(indicator_instance)
	
	if crit_level == 0:
		AudioManager.hit_sfx.play()
	elif crit_level == 1:
		AudioManager.crit_sfx.play()
	elif crit_level == 2:
		AudioManager.doublecrit_sfx.play()
	elif crit_level == 3:
		AudioManager.triplecrit_sfx.play()
	else:
		AudioManager.multicrit_sfx.play()

func check_damage_indicator_setting(crit_level : int) -> bool:
	match Settings.get_damage_indicators_enabled():
		Settings.damage_indicators.ALWAYS:
			return true
		Settings.damage_indicators.ONLY_CRITS:
			if crit_level > 0:
				return true
			return false
		Settings.damage_indicators.NEVER:
			return false
		_:
			push_error("Invalid damage indicator setting!")
			return false
