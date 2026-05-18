extends Node

@export var path : Path2D
@export var waves : Array[Wave]

#var mob_preload = preload("res://mobs/scenes/red_mob.tscn")
#var mob_to_spawn : Mob

var wave_at : int = 0

#func _on_spawn_interval_timeout() -> void:
	#var pathfollow = PathFollow2D.new()
	#pathfollow.loop = false
	#path.add_child(pathfollow)
	#mob_to_spawn = mob_preload.instantiate()
	#mob_to_spawn.player = get_parent()
	#pathfollow.add_child(mob_to_spawn)

func _ready() -> void:
	for i in waves:
		i.spawn_reached.connect(_on_wave_spawn_reached)
	waves[0].start()

func _on_wave_spawn_reached(mob : Mob) -> void:
	var pathfollow = PathFollow2D.new()
	pathfollow.loop = false
	path.add_child(pathfollow)
	mob.player = get_parent()
	pathfollow.add_child(mob)
