extends Container

@export var side_panel : PanelContainer
@export var upgrade_panel : PanelContainer

var slot_machine_preload = preload("res://slot_machine.tscn")

var player : Node
var slot_machine : Node

signal tower_selected(tower : Tower)
signal next_wave_pressed

func _ready() -> void:
	player = get_parent()
	
	side_panel.buy_button.pressed.connect(_on_buy_button_pressed)
	side_panel.tower_data_container.upgrade_tower.connect(_on_upgrade_button_pressed)
	side_panel.next_wave_button.pressed.connect(_on_next_wave_button_pressed)
	upgrade_panel.upgrade_selected.connect(_on_upgrade_selected)

func hide_side_panel() -> void:
	side_panel.visible = false
func show_side_panel() -> void:
	side_panel.visible = true

func hide_upgrade_panel() -> void:
	upgrade_panel.visible = false
func show_upgrade_panel() -> void:
	
	upgrade_panel.visible = true

func start_slot_machine() -> void:
	#Re-enable 2D physics while the game is paused or Area2D will not detect collision
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	
	hide_side_panel()
	hide_upgrade_panel()
	
	slot_machine = slot_machine_preload.instantiate()
	slot_machine.tower_selected.connect(_on_slot_machine_tower_selected)
	add_child(slot_machine)

func _on_buy_button_pressed() -> void:
	if player.spend_money(player.tower_cost):
		start_slot_machine()

func _on_upgrade_button_pressed(tower : Tower) -> void:
	if player.spend_money(tower.upgrade_cost):
		tower.upgrade_cost = tower.upgrade_cost ** 1.2
		
		get_tree().paused = true
		hide_side_panel()
		upgrade_panel.tower_to_upgrade = tower
		upgrade_panel.generate_upgrade_options()
		show_upgrade_panel()

func _on_upgrade_selected(tower : Tower, att : int, amount : float) -> void:
	tower.upgrade_attribute(att, amount)
	side_panel.tower_data_container.refresh_with_new_tower(tower)
	
	get_tree().paused = false
	show_side_panel()
	hide_upgrade_panel()

func _on_slot_machine_tower_selected(tower : Tower):
	get_tree().paused = false
	
	tower_selected.emit(tower)
	slot_machine.queue_free()

func _on_next_wave_button_pressed() -> void:
	next_wave_pressed.emit()
