extends Container

@export var side_panel : PanelContainer
@export var upgrade_panel : PanelContainer

var player : Node

func _ready() -> void:
	player = get_parent()
	
	side_panel
	side_panel.tower_data_container.upgrade_tower.connect(_on_upgrade_button_pressed)
	upgrade_panel.upgrade_selected.connect(_on_upgrade_selected)

func hide_side_panel() -> void:
	side_panel.visible = false
func show_side_panel() -> void:
	side_panel.visible = true

func hide_upgrade_panel() -> void:
	upgrade_panel.visible = false
func show_upgrade_panel() -> void:
	upgrade_panel.visible = true

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
	
