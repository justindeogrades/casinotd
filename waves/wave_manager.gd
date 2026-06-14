extends Node

@export var path : Path2D
@export var waves : Array[Wave]

#var mob_preload = preload("res://mobs/scenes/red_mob.tscn")
#var mob_to_spawn : Mob

var wave_at : int = 0
var wave_active : bool = false

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
		i.wave_ended.connect(_on_wave_ended)

func start_next_wave() -> void:
	if not wave_active:
		waves[wave_at].start()
		wave_active = true

func _on_wave_spawn_reached(mob : Mob) -> void:
	var pathfollow = PathFollow2D.new()
	pathfollow.loop = false
	pathfollow.rotates = false
	path.add_child(pathfollow)
	mob.player = get_parent()
	pathfollow.add_child(mob)

func _on_wave_ended() -> void:
	wave_active = false
	wave_at += 1
