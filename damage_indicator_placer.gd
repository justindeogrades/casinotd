extends Node

@export var damage_indicator_resource : Resource

func create_damage_indicator(amount : int, crit_level : int, pos : Vector2):
	if Settings.get_damage_indicators_enabled():
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
