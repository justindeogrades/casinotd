extends Control

@export var name_and_level_label : Label
@export var total_damage_label : Label
@export var attribute_names_label : Label
@export var attribute_data_label : Label
@export var upgrade_button : Button

var tower : Tower = null
var player : Node

signal upgrade_tower

#func _ready() -> void:
	#call_deferred("set_global_position", Vector2(0,0))
	#
	#visible = false

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

#func close() -> void:
	#visible = false
	#tower.set_range_indicator_visibility(false)


func _on_upgrade_button_pressed() -> void:
	#Terrible coding change later
	#if player.spend_money(tower.upgrade_cost):
		#tower.level += 1
		#tower.upgrade_cost = tower.upgrade_cost ** 1.2
		#
		##Placeholder upgrades
		#tower.attack_speed += 20
		#tower.range += 10
		#
		#tower.update_range()
		#tower.update_cooldown()
		#
		#refresh_with_new_tower(tower)
	upgrade_tower.emit(tower)
