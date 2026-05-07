extends Control

@export var name_and_level_label : Label
@export var total_damage_label : Label
@export var priority_label : Label
@export var attribute_names_label : Label
@export var attribute_data_label : Label
@export var upgrade_button : Button

var tower : Tower = null
var player : Node

signal upgrade_tower

#func _ready() -> void:
	#update_priority_label()

func _process(delta: float) -> void:
	refresh()

func refresh() -> void:
	if tower != null:
		total_damage_label.text = str(tower.total_damage_dealt) + " damage dealt"

func refresh_with_new_tower(new_tower : Tower) -> void:
	if tower != null:
		tower.set_range_indicator_visibility(false)
	tower = new_tower
	tower.set_range_indicator_visibility(true)
	
	name_and_level_label.text = "Level " + str(tower.level) + " " + str(tower.tower_name)
	total_damage_label.text = str(tower.total_damage_dealt) + " damage dealt"
	
	var format_attribute_names_string = "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s"
	attribute_names_label.text = format_attribute_names_string % [
	"Damage:",
	"Attack speed:",
	"Range:",
	"Crit chance:",
	"Crit multiplier:",
	"Projectile speed:",
	"Projectile count:",
	"Pierce:"
	]
	var format_attribute_data_string = "%.1f\n%.1f\n%.1f\n%.1f%%\n%.1fx\n%.1f\n%.f\n%.f"
	attribute_data_label.text = format_attribute_data_string % [
		tower.attribute[G.att.DAMAGE],
		tower.attribute[G.att.ATTACK_SPEED],
		tower.attribute[G.att.RANGE],
		tower.attribute[G.att.CRIT_CHANCE],
		tower.attribute[G.att.CRIT_MULT],
		tower.attribute[G.att.PROJ_SPEED],
		tower.attribute[G.att.PROJ_COUNT],
		tower.attribute[G.att.PIERCE]
	]
	
	upgrade_button.text = "Upgrade - $" + str(tower.upgrade_cost)
	
	update_priority_label()

func update_priority_label() -> void:
	var prio = tower.get_target_priority()
	priority_label.text = target_priority_to_string(prio)

func target_priority_to_string(prio : int) -> String:
	match prio:
		G.prio.FIRST:
			return "First"
		G.prio.LAST:
			return "Last"
		G.prio.CLOSE:
			return "Close"
		_:
			push_error("Invalid target priority!")
			return ""

func _on_upgrade_button_pressed() -> void:
	upgrade_tower.emit(tower)


func _on_prio_back_pressed() -> void:
	var new_prio = posmod(tower.get_target_priority() - 1, G.prio.size())
	print_debug("setting target prio to " + str(new_prio))
	tower.set_target_priority(new_prio)
	update_priority_label()

func _on_prio_forward_pressed() -> void:
	var new_prio = posmod(tower.get_target_priority() + 1, G.prio.size())
	print_debug("setting target prio to " + str(new_prio))
	tower.set_target_priority(new_prio)
	update_priority_label()
