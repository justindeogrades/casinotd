extends Node

@export_category("HUD")
@export var gui_manager : Control
@export var damage_indicator_placer : Node
@export_category("Stats")
@export var max_lives : int = 100
@export_category("Actions")
@export var tower_placer : Node

var side_panel : PanelContainer

var money : int = 500
var lives : int = max_lives

var tower_cost : int = 20

var placed_towers : Array[Tower]

func _ready() -> void:
	side_panel = gui_manager.get_child(0)
	
	gui_manager.tower_selected.connect(_on_gui_manager_tower_selected)
	
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

func _on_tower_clicked(tower) -> void:
	side_panel.tower_data_container.refresh_with_new_tower(tower)

func _on_gui_manager_tower_selected(tower : Tower) -> void:
	tower_cost = tower_cost ** 1.2
	refresh_money_label()
	side_panel.refresh_buy_button()
	tower_placer.create_temp_tower(tower)

func _on_tower_created(new_tower : Tower) -> void:
	new_tower.clicked.connect(_on_tower_clicked)
	new_tower.damage_dealt.connect(_on_tower_damage_dealt)
	
	placed_towers.append(new_tower)
	gui_manager.hide_side_panel()
	get_tree().paused = true

func _on_tower_placed() -> void:
	gui_manager.show_side_panel()
	get_tree().paused = false

func _on_tower_damage_dealt(amount : int, crit_level : int, pos : Vector2) -> void:
	damage_indicator_placer.create_damage_indicator(amount, crit_level, pos)

func is_any_tower_mouseovered() -> bool:
	for tower_at in placed_towers:
		if tower_at.mouseovered:
			return true
	return false
