extends PanelContainer

@export var money_label : Label
@export var lives_label : Label
@export var tower_data_container : VBoxContainer
@export var quick_spins_box : CheckBox
@export var buy_button : Button
@export var next_wave_button : Button

var player : Node
var buttons : Array[Button]

func _ready() -> void:
	player = get_parent().get_parent()
	tower_data_container.player = player
	
	init_buttons_array()
	
	refresh_buy_button()

func init_buttons_array() -> void:
	buttons.append(buy_button)
	buttons.append(next_wave_button)
	buttons.append(quick_spins_box)
	buttons.append(tower_data_container.prio_forward_button)
	buttons.append(tower_data_container.prio_back_button)
	buttons.append(tower_data_container.upgrade_button)

func set_all_buttons_disabled(d : bool) -> void:
	for i in buttons:
		i.disabled = d

func refresh_buy_button() -> void:
	buy_button.text = "Buy tower - $" + str(player.tower_cost)

#Replaced by function in the tower data container
#func set_tower_data_container_visible(vis : bool) -> void:
	#tower_data_container.visible = vis
