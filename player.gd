extends Node

@export_category("HUD")
@export var gui_manager : Control
@export var damage_indicator_placer : Node
@export_category("Stats")
@export var max_lives : int = 100
@export_category("Actions")
@export var tower_placer : Node
@export var wave_manager : Node

var side_panel : PanelContainer
var tower_data_container : VBoxContainer

var money : int = 500
var lives : int = max_lives

var tower_cost : int = 20

var placed_towers : Array[Tower]

var selected_tower : Tower = null

func _ready() -> void:
	side_panel = gui_manager.get_child(0)
	tower_data_container = side_panel.tower_data_container
	tower_data_container.set_enabled(false)
	
	gui_manager.tower_selected.connect(_on_gui_manager_tower_selected)
	gui_manager.next_wave_pressed.connect(_on_next_wave_pressed)
	
	refresh_money_label()
	refresh_lives_label()
	tower_placer.tower_created.connect(_on_tower_created)
	tower_placer.tower_placed.connect(_on_tower_placed)

#func _process(delta : float) -> void:
	#if Input.is_action_just_released("place_tower"):
		#var new_tower = tower_placer.place_tower(get_viewport().get_mouse_position())
		##new_tower.mousebox/$CollisionShape2D.mouse_entered.connect(_on_tower_mouse_entered)
		##new_tower.mousebox/$CollisionShape2D.mouse_exited.connect(_on_tower_mouse_exited)
		#if new_tower != null:
			#new_tower.clicked.connect(_on_tower_clicked)
			#placed_towers.append(new_tower)

func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_released("place_tower") and not is_any_tower_mouseovered() and selected_tower != null:
		#deselect_tower(selected_tower)
	if Input.is_action_just_pressed("place_tower") and not is_tower_mouseovered(selected_tower) and selected_tower != null:
		deselect_tower(selected_tower)
	
	if Input.is_action_just_pressed("cheat_tower_1"):
		tower_placer.create_temp_tower(load("res://towers/scenes/mrmouse.tscn").instantiate( ))
	if Input.is_action_just_pressed("cheat_tower_2"):
		tower_placer.create_temp_tower(load("res://towers/scenes/pirate.tscn").instantiate( ))

func spend_money(amount : int) -> bool:
	if money >= amount:
		update_money(amount * -1)
		return true
	return false

func update_money(amount : int) -> void:
	money += amount
	refresh_money_label()

func refresh_money_label() -> void:
	side_panel.money_label.text = "Money: " + str(money)

func update_lives(amount : int) -> void:
	lives += amount
	refresh_lives_label()

func refresh_lives_label() -> void:
	side_panel.lives_label.text = "Lives: " + str(lives)

#Currently the selected tower will be displayed over other towers
func select_tower(tower : Tower) -> void:
	if selected_tower != null:
		deselect_tower(selected_tower)
	
	selected_tower = tower
	
	#side_panel.set_tower_data_container_visible(true)
	tower_data_container.set_enabled(true)
	tower.set_range_indicator_visibility(true)
	side_panel.tower_data_container.refresh_with_new_tower(tower)
	
	tower.set_z_index(0)
func deselect_tower(tower : Tower) -> void:
	selected_tower = null
	
	#side_panel.set_tower_data_container_visible(false)
	tower_data_container.set_enabled(false)
	tower.set_range_indicator_visibility(false)
	
	tower.set_z_index(1)
func _on_tower_clicked(tower : Tower) -> void:
	select_tower(tower)
	#call_deferred("select_tower", tower)

func _on_gui_manager_tower_selected(tower : Tower) -> void:
	tower_cost = tower_cost ** 1.2
	refresh_money_label()
	side_panel.refresh_buy_button()
	tower_placer.create_temp_tower(tower)

func _on_tower_created(new_tower : Tower) -> void:
	new_tower.clicked.connect(_on_tower_clicked)
	new_tower.damage_dealt.connect(_on_tower_damage_dealt)
	
	placed_towers.append(new_tower)
	#gui_manager.hide_side_panel()
	side_panel.set_all_buttons_disabled(true)
	get_tree().paused = true

func _on_tower_placed(new_tower : Tower) -> void:
	#gui_manager.show_side_panel()
	side_panel.set_all_buttons_disabled(false)
	get_tree().paused = false
	
	select_tower(new_tower)

func _on_tower_damage_dealt(amount : int, crit_level : int, pos : Vector2) -> void:
	damage_indicator_placer.create_damage_indicator(amount, crit_level, pos)

func _on_next_wave_pressed() -> void:
	wave_manager.start_next_wave()

func is_tower_mouseovered(tower : Tower) -> bool:
	if tower != null:
		return tower.mouseovered
	return false
func is_any_tower_mouseovered() -> bool:
	for tower_at in placed_towers:
		if tower_at.mouseovered:
			return true
	return false

#func get_mouseovered_tower() -> Tower:
	#for tower_at in placed_towers:
		#if tower_at.mouseovered:
			#return tower_at
	#return null
