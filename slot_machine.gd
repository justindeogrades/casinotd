extends Node

var symbol_path = "res://symbol.tscn"

@export var base_speed : float
@export var total_spin_time : float
@export var speed_curve : Curve

@onready var speed : float = base_speed

var frames_since_start : float = 0

var selected_symbol : Node2D = null

var symbol : Array[Node2D]

signal tower_selected(tower : Tower)

func _ready() -> void:
	create_symbol()



func _process(delta: float) -> void:
	var x = frames_since_start / (total_spin_time * 60)
	
	speed = speed_curve.sample(x) * base_speed
	
	if not symbol.is_empty():
		for i in symbol:
			i.set_speed(speed)
	
	frames_since_start += 1
	
	if x >= 1:
		tower_selected.emit(selected_symbol.get_tower())
	
	print_debug(selected_symbol)

func create_symbol() -> void:
	var symbol_instance = load(symbol_path).instantiate()
	symbol_instance.init(1)
	symbol_instance.mid_reached.connect(_on_symbol_mid_reached)
	symbol_instance.end_reached.connect(_on_symbol_end_reached)
	symbol.append(symbol_instance)
	$SymbolParent.add_child(symbol_instance)

func _on_symbol_mid_reached() -> void:
	create_symbol()

func _on_symbol_end_reached(s : Node2D) -> void:
	symbol.erase(s)

func _on_line_area_entered(area: Area2D) -> void:
	selected_symbol = area.get_parent()
	print_debug("area entered")
