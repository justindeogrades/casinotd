extends Node

func create_damage_indicator(amount : int, is_crit : bool, pos : Vector2):
	var indicator_instance = load("res://damage_indicator.tscn").instantiate()
	indicator_instance.init(amount, is_crit, pos)
	add_child(indicator_instance)
