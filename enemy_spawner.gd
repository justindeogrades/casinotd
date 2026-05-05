extends Node

@export var path : Path2D
var mob_preload = preload("res://mobs/scenes/red_mob.tscn")
var mob_to_spawn : Mob

func _on_spawn_interval_timeout() -> void:
	var pathfollow = PathFollow2D.new()
	pathfollow.loop = false
	path.add_child(pathfollow)
	mob_to_spawn = mob_preload.instantiate()
	mob_to_spawn.player = get_parent()
	pathfollow.add_child(mob_to_spawn)
