class_name WaveSegment
extends Resource

@export var mob_preload : Resource
@export var mob_count : int
@export var spawn_interval : float

#var mob : Mob
#var interval : float

#func _init(p : Resource, c : int, i : float) -> void:
	#mob_preload = p
	#spawn_interval = i
