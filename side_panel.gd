extends PanelContainer

@export var money_label : Label
@export var lives_label : Label
@export var tower_data_container : VBoxContainer
@export var quick_spins_box : CheckBox
@export var buy_button : Button
@export var next_wave_button : Button

var player : Node
var buttons : Array[Button]

signal update_requested

func _ready() -> void:
	player = get_parent().get_parent()
	tower_data_container.player = player
	
	init_buttons_array()
	
	update_requested.emit()

func init_buttons_array() -> void:
	buttons.append(buy_button)
	buttons.append(next_wave_button)
	buttons.append(quick_spins_box)
	buttons.append(tower_data_container.prio_forward_button)
	buttons.append(tower_data_container.prio_back_button)
	buttons.append(tower_data_container.upgrade_button)

#ONLY to be called from the player
func update_all(money : int, lives : int, tower_cost : int, wave_active : bool):
	money_label.text = "Money: " + str(money)
	lives_label.text = "Lives: " + str(lives)
	
	update_buy_button(money, tower_cost)
	tower_data_container.update_upgrade_button()
	next_wave_button.disabled = wave_active

func set_all_buttons_disabled(d : bool) -> void:
	for i in buttons:
		i.disabled = d
	
	if not d:
		update_requested.emit()

func update_buy_button(money : int, tower_cost : int) -> void:
	buy_button.text = "Buy tower - $" + str(tower_cost)
	
	if tower_cost <= money:
		buy_button.disabled = false
	else:
		buy_button.disabled = true

#Replaced by function in the tower data container
#func set_tower_data_container_visible(vis : bool) -> void:
	#tower_data_container.visible = vis
