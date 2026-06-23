extends Node

@export var track_polygon : Polygon2D

var tower_preload = preload("res://towers/scenes/common_tower.tscn")
var tower_ghost_preload = preload("res://tower_ghost.tscn")
var tower_to_place : Tower = null
var tower_ghost : Sprite2D
var temp_tower : Tower = null

signal tower_created(tower : Tower)
signal tower_placed(tower : Tower)

#func _ready() -> void:
	#var tower = place_tower(Vector2(9999,9999))
	#
	#tower_ghost = tower_ghost_preload.instantiate()
	#add_child(tower_ghost)
	#tower_ghost.init(tower)

func _process(delta : float) -> void:
	if tower_ghost != null:
		if get_tower_placement_validity(tower_ghost.position):
			tower_ghost.modulate = Color(1, 1, 1, 1)
		else:
			tower_ghost.modulate = Color(1, 0, 0, 1)
	
	if Input.is_action_just_pressed("place_tower") and tower_ghost != null:
		if get_tower_placement_validity(tower_ghost.position):
			place_tower(get_viewport().get_mouse_position())
		#new_tower.mousebox/$CollisionShape2D.mouse_entered.connect(_on_tower_mouse_entered)
		#new_tower.mousebox/$CollisionShape2D.mouse_exited.connect(_on_tower_mouse_exited)
		#if new_tower != null:
			#new_tower.clicked.connect(_on_tower_clicked)
			#placed_towers.append(new_tower)

func create_temp_tower(t : Tower) -> void:
	temp_tower = create_tower(t, Vector2(9999,9999))
	
	tower_ghost = tower_ghost_preload.instantiate()
	add_child(tower_ghost)
	tower_ghost.init(temp_tower)
	
#func _process(delta: float) -> void:
	#var mouse_pos = get_viewport().get_mouse_position()
	#
	#if Input.is_action_just_released("place_tower"):
		#if not Geometry2D.is_point_in_polygon(mouse_pos, track_polygon.polygon):
			#tower_to_place = tower_preload.instantiate()
			#add_child(tower_to_place)
			#tower_to_place.position = get_viewport().get_mouse_position()

func create_tower(tower_to_place : Tower, pos : Vector2):
	if not Geometry2D.is_point_in_polygon(pos, track_polygon.polygon):
		#tower_to_place = tower_preload.instantiate()
		add_child(tower_to_place)
		tower_to_place.position = pos
		tower_created.emit(tower_to_place)
		return tower_to_place

#Why does this return a value?
func place_tower(pos : Vector2) -> Tower:
	#if get_parent().is_any_tower_mouseovered():
		#return null
	#
	#if not Geometry2D.is_point_in_polygon(pos, track_polygon.polygon):
		#temp_tower.position = pos
		#tower_ghost.queue_free()
		#tower_placed.emit(temp_tower)
		#return temp_tower
	#return null
	
	#We check for placement validity in the process function
	temp_tower.position = pos
	tower_ghost.queue_free()
	tower_placed.emit(temp_tower)
	return temp_tower

func get_tower_placement_validity(pos : Vector2) -> bool:
	if Geometry2D.is_point_in_polygon(pos, track_polygon.polygon):
		return false
	if get_parent().is_any_tower_mouseovered():
		return false
	if pos.x >= get_viewport().get_visible_rect().size.x * 0.8:
		return false
	return true
