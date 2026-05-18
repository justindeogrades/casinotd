extends Node
class_name Wave

@export var segments : Array[WaveSegment]
@export var interval_timer : Timer

#We count segments starting from 0 but mobs from 1
var segment_at : int = 0
var mob_at : int = 0

signal spawn_reached(mob : Mob)

func start() -> void:
	spawn_mob(segments[segment_at].mob_preload.instantiate())
func end() -> void:
	print_debug("wave ended!")

func spawn_mob(mob : Mob):
	spawn_reached.emit(mob)
	print_debug("Spawning mob " + str(mob_at) + " in segment " + str(segment_at))
	mob_at += 1
	interval_timer.start(segments[segment_at].spawn_interval)

func _on_interval_timer_timeout() -> void:
	decide_what_to_do_next()

func decide_what_to_do_next() -> void:
	if mob_at < segments[segment_at].mob_count:
		spawn_mob(segments[segment_at].mob_preload.instantiate())
	else:
		if segment_at + 1 < segments.size():
			segment_at += 1
			mob_at = 0
			spawn_mob(segments[segment_at].mob_preload.instantiate())
		else:
			end()
