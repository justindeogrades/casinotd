extends Node

var symbol_path = "res://slot machine/symbol.tscn"

var common_preload = preload("res://towers/scenes/specimen.tscn")
var uncommon_preload = preload("res://towers/scenes/whitebeard.tscn")
var rare_preload = preload("res://towers/scenes/fishbowl.tscn")
var legendary_preload = preload("res://towers/scenes/mrmouse.tscn")

@export_category("Tower resources")
@export var all_towers : Array[Resource]
@export_category("Values")
@export var rarity_probabilities : Array[int] = [50, 30, 15, 5]
@export var base_speed : float
@export var base_spin_time : float
@export var speed_randomness_range : float
@export var spin_time_randomness_range : float
@export var symbol_count : int
@export var speed_curve : Curve

#Initialize with 4 empty lists
var sorted_towers : Array[Array] = [[], [], [], []]

var speed : float
var spin_time : float

var quick_spins : bool = false
var quick_spins_time_mult : float = 0.25

var frames_since_start : float = 0
var next_rarity : int = 0

var symbol : Array[Node2D]
var selected_symbol : Node2D = null

var viewport_y = 1080
var symbol_y_offset = 500

signal tower_selected(tower : Tower, bannable : bool)

func _ready() -> void:
	#Centers the line
	$Line.position.y = $Line.get_viewport_rect().size.y / 2

func init(quick_spins_enabled : bool, banned_towers : Array) -> void:
	#Does nothing because speed is set every frame?
	#speed = randomize_speed(base_speed, speed_randomness_range)
	
	sort_towers(banned_towers)
	
	quick_spins = quick_spins_enabled
	
	spin_time = randomize_time(base_spin_time, spin_time_randomness_range)
	if quick_spins_enabled:
		spin_time *= quick_spins_time_mult
	
	#print_debug("final speed: " + str(speed))
	#print_debug("final spin time: " + str(spin_time))
	
	for i in symbol_count:
		#360 is the symbol height
		#create_symbol(540 - 360 * i)
		create_symbol(viewport_y - symbol_y_offset * i)
	
	#Ensures it appears in front of symbols
	$TextureRect.set_z_index(3)



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
		var selected_tower = selected_symbol.get_tower()
		tower_selected.emit(selected_tower, is_tower_bannable(selected_tower))

func sort_towers(banned_towers : Array) -> void:
	for i in all_towers:
		var tower_instance = i.instantiate()
		if not is_tower_banned(tower_instance, banned_towers):
			sorted_towers[tower_instance.get_rarity()].append(tower_instance)

func is_tower_banned(tower : Tower, banned_towers : Array) -> bool:
	for b in banned_towers:
		if tower.tower_name == b.tower_name:
			return true
	return false
func is_tower_bannable(tower : Tower) -> bool:
	if sorted_towers[tower.get_rarity()].size() <= 1:
		return false
	return true

#Is it necessary to have two of the exact same function?
func randomize_speed(base : float, range : float) -> float:
	var offset = randf_range(-range, range)
	return base + offset
func randomize_time(base : float, range : float) -> float:
	var offset = randf_range(-range, range)
	return base + offset

#Old, we're redoing this
#func create_symbol(ypos : int) -> void:
	##Choose tower preload to pass
	#var preload_to_pass = choose_tower_preload(next_rarity)
	#
	#var symbol_instance = load(symbol_path).instantiate()
	#symbol_instance.init(1, preload_to_pass, ypos)
	#symbol_instance.mid_reached.connect(_on_symbol_mid_reached)
	#symbol_instance.end_reached.connect(_on_symbol_end_reached)
	#symbol.append(symbol_instance)
	#$SymbolParent.add_child(symbol_instance)
	#
	#next_rarity = (next_rarity + 1) % 4

func create_symbol(ypos : int) -> void:
	#Choose tower preload to pass
	var tower = get_random_tower_with_rarity(get_random_rarity())
	
	var symbol_instance = load(symbol_path).instantiate()
	symbol_instance.init(1, tower, ypos)
	#symbol_instance.mid_reached.connect(_on_symbol_mid_reached)
	symbol_instance.end_reached.connect(_on_symbol_end_reached)
	symbol.append(symbol_instance)
	$SymbolParent.add_child(symbol_instance)

func get_random_rarity() -> int:
	var challenge = randi_range(0, 100)
	if challenge < rarity_probabilities[G.rarity.LEGENDARY]:
		return G.rarity.LEGENDARY
	if challenge < rarity_probabilities[G.rarity.LEGENDARY] + rarity_probabilities[G.rarity.RARE]:
		return G.rarity.RARE
	if challenge < rarity_probabilities[G.rarity.LEGENDARY] + rarity_probabilities[G.rarity.RARE] + rarity_probabilities[G.rarity.UNCOMMON]:
		return G.rarity.UNCOMMON
	return G.rarity.COMMON

func get_random_tower_with_rarity(rarity : int) -> Tower:
	var upper_bound = sorted_towers[rarity].size() - 1
	return sorted_towers[rarity][randi_range(0, upper_bound)]

#Made redundant
#func choose_tower_preload(rarity : int) -> Resource:
	#match rarity:
		#0:
			#return common_preload
		#1:
			#return uncommon_preload
		#2:
			#return rare_preload
		#3:
			#return legendary_preload
		#_:
			#push_error("Invalid rarity in slot machine!")
			#return null

#Made redundant
#func _on_symbol_mid_reached() -> void:
	##create_symbol(symbol[symbol.size() - 1].position.y - 180)
	#pass

func _on_symbol_end_reached(s : Node2D) -> void:
	symbol.erase(s)

func _on_line_area_entered(area: Area2D) -> void:
	selected_symbol = area.get_parent()
