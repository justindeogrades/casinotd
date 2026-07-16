extends Container

@export var side_panel : PanelContainer
@export var upgrade_panel : PanelContainer

@export var game_over_panel_resource : Resource

var slot_machine_preload = preload("res://slot machine/slot_machine.tscn")
var tower_selected_panel_preload = preload("res://tower_selected_panel.tscn")

var player : Node
var slot_machine : Node
var tower_selected_panel : PanelContainer
var game_over_panel : PanelContainer

var reroll_cost_mult : float = 0.25
var quick_spins_enabled : bool = false

signal tower_selected(tower : Tower)
signal next_wave_pressed
signal game_over_confirmed

func _ready() -> void:
	player = get_parent()
	
	side_panel.quick_spins_box.pressed.connect(_on_quick_spins_box_pressed.bind(side_panel.quick_spins_box))
	#side_panel.quick_spins_box.button_up.connect(_on_quick_spins_box_up)
	side_panel.buy_button.pressed.connect(_on_buy_button_pressed)
	side_panel.tower_data_container.upgrade_tower.connect(_on_upgrade_button_pressed)
	side_panel.next_wave_button.pressed.connect(_on_next_wave_button_pressed)
	upgrade_panel.upgrade_selected.connect(_on_upgrade_selected)
	upgrade_panel.reroll_pressed.connect(_on_reroll_pressed)
	
	set_z_index(1000)

#Redundant
#func hide_side_panel() -> void:
	#side_panel.visible = false
#func show_side_panel() -> void:
	#side_panel.visible = true

func hide_upgrade_panel() -> void:
	upgrade_panel.visible = false
func show_upgrade_panel() -> void:
	
	upgrade_panel.visible = true

func init_game_over() -> void:
	get_tree().paused = true
	side_panel.set_all_buttons_disabled(true)
	
	game_over_panel = game_over_panel_resource.instantiate()
	game_over_panel.confirm_button.pressed.connect(_on_game_over_confirm_button_pressed)
	add_child(game_over_panel)

func start_slot_machine(is_reroll : bool) -> void:
	#Re-enable 2D physics while the game is paused or Area2D will not detect collision
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	
	#Switching hiding the side panel for disabling its buttons
	#hide_side_panel()
	#hide_upgrade_panel()
	side_panel.set_all_buttons_disabled(true)
	
	slot_machine = slot_machine_preload.instantiate()
	slot_machine.tower_selected.connect(_on_slot_machine_tower_selected)
	slot_machine.init(quick_spins_enabled)
	add_child(slot_machine)

func create_tower_selected_panel(tower : Tower) -> void:
	var reroll_cost = compute_reroll_cost()
	
	tower_selected_panel = tower_selected_panel_preload.instantiate()
	tower_selected_panel.init(tower, reroll_cost)
	tower_selected_panel.accepted.connect(_on_tower_selected_panel_accepted)
	tower_selected_panel.rerolled.connect(_on_tower_selected_panel_rerolled)
	add_child(tower_selected_panel)

func compute_reroll_cost() -> int:
	#Casting player tower cost to float for division then back to int cause i dont fucking care anymore
	return int(float(player.tower_cost) * reroll_cost_mult)

#func _on_quick_spins_box_down() -> void:
	#quick_spins_enabled = true
	#print_debug(quick_spins_enabled)
#func _on_quick_spins_box_up() -> void:
	#quick_spins_enabled = false
	#print_debug(quick_spins_enabled)
func _on_quick_spins_box_pressed(box : CheckBox) -> void:
	quick_spins_enabled = box.button_pressed
	print_debug(quick_spins_enabled)

func _on_buy_button_pressed() -> void:
	if player.spend_money(player.tower_cost):
		start_slot_machine(false)
	#Get rid of this later lmao
	else:
		side_panel.buy_button.text = "try again when u get some money, buddy"

func _on_upgrade_button_pressed(tower : Tower) -> void:
	if player.spend_money(tower.upgrade_cost):
		get_tree().paused = true
		#hide_side_panel()
		side_panel.set_all_buttons_disabled(true)
		upgrade_panel.tower_to_upgrade = tower
		upgrade_panel.refresh_reroll_button(true)
		upgrade_panel.generate_upgrade_options()
		upgrade_panel.enter_cards()
		show_upgrade_panel()

#This is for rerolling upgrades
func _on_reroll_pressed() -> void:
	if player.spend_money(upgrade_panel.reroll_cost):
		upgrade_panel.refresh_reroll_button(false)
		upgrade_panel.generate_upgrade_options()
		upgrade_panel.enter_cards()

func _on_upgrade_selected(tower : Tower, att : int, amount : float) -> void:
	tower.upgrade_attribute(att, amount)
	tower.upgrade_cost = tower.upgrade_cost ** 1.2
	side_panel.tower_data_container.refresh_with_new_tower(tower)
	
	get_tree().paused = false
	side_panel.set_all_buttons_disabled(false)
	#show_side_panel()
	hide_upgrade_panel()

func _on_slot_machine_tower_selected(tower : Tower):
	#We don't pause because we bring out the tower selected panel next
	#Tower placer will pause too
	#get_tree().paused = false
	
	slot_machine.queue_free()
	create_tower_selected_panel(tower)

func _on_tower_selected_panel_accepted(tower : Tower) -> void:
	tower_selected.emit(tower)
	tower_selected_panel.queue_free()

#This is for rerolling towers
func _on_tower_selected_panel_rerolled(reroll_cost : float) -> void:
	if player.spend_money(int(reroll_cost)):
		start_slot_machine(true)
		tower_selected_panel.queue_free()

func _on_next_wave_button_pressed() -> void:
	next_wave_pressed.emit()

func _on_game_over_confirm_button_pressed() -> void:
	game_over_confirmed.emit()
