extends Node

func create_damage_indicator(amount : int, crit_level : int, pos : Vector2):
	var indicator_instance = load("res://damage_indicator.tscn").instantiate()
	indicator_instance.init(amount, crit_level, pos)
	add_child(indicator_instance)
