extends Node

var symbol_path = "res://symbol.tscn"

var common_preload = preload("res://towers/scenes/common_tower.tscn")
var uncommon_preload = preload("res://towers/scenes/uncommon_tower.tscn")
var rare_preload = preload("res://towers/scenes/rare_tower.tscn")
var legendary_preload = preload("res://towers/scenes/legendary_tower.tscn")

@export var base_speed : float
@export var base_spin_time : float
@export var speed_randomness_range : float
@export var spin_time_randomness_range : float
@export var speed_curve : Curve

var speed : float
var spin_time : float

var quick_spins : bool = false
var quick_spins_time_mult : float = 0.25

var frames_since_start : float = 0
var next_rarity : int = 0

var symbol : Array[Node2D]
var selected_symbol : Node2D = null

signal tower_selected(tower : Tower)

#func _ready() -> void:
	#speed = randomize_speed(base_speed, speed_randomness_range)
	#spin_time = randomize_time(base_spin_time, spin_time_randomness_range)
	#create_symbol()

func init(quick_spins_enabled : bool) -> void:
	#Does nothing because speed is set every frame?
	#speed = randomize_speed(base_speed, speed_randomness_range)
	
	quick_spins = quick_spins_enabled
	
	spin_time = randomize_time(base_spin_time, spin_time_randomness_range)
	if quick_spins_enabled:
		spin_time *= quick_spins_time_mult
	
	#print_debug("final speed: " + str(speed))
	#print_debug("final spin time: " + str(spin_time))
	
	create_symbol()



func _process(delta: float) -> void:
	var x = frames_since_start / (spin_time * 60)
	
	speed = speed_curve.sample(x) * base_speed
	if quick_spins:
		speed *= 1 / quick_spins_time_mult
	
	if not symbol.is_empty():
		for i in symbol:
			i.set_speed(speed)
	
	frames_since_start += 1
	
	if x >= 1:
		tower_selected.emit(selected_symbol.get_tower())

#Is it necessary to have two of the exact same function?
func randomize_speed(base : float, range : float) -> float:
	var offset = randf_range(-range, range)
	return base + offset
func randomize_time(base : float, range : float) -> float:
	var offset = randf_range(-range, range)
	return base + offset

func create_symbol() -> void:
	#Choose tower preload to pass
	var preload_to_pass = choose_tower_preload(next_rarity)
	
	var symbol_instance = load(symbol_path).instantiate()
	symbol_instance.init(1, preload_to_pass)
	symbol_instance.mid_reached.connect(_on_symbol_mid_reached)
	symbol_instance.end_reached.connect(_on_symbol_end_reached)
	symbol.append(symbol_instance)
	$SymbolParent.add_child(symbol_instance)
	
	next_rarity = (next_rarity + 1) % 4

func choose_tower_preload(rarity : int) -> Resource:
	match rarity:
		0:
			return common_preload
		1:
			return uncommon_preload
		2:
			return rare_preload
		3:
			return legendary_preload
		_:
			push_error("Invalid rarity in slot machine!")
			return null

func _on_symbol_mid_reached() -> void:
	create_symbol()

func _on_symbol_end_reached(s : Node2D) -> void:
	symbol.erase(s)

func _on_line_area_entered(area: Area2D) -> void:
	selected_symbol = area.get_parent()
