extends PanelContainer

@export var money_label : Label
@export var wave_label : Label
@export var money_feed_container : VBoxContainer
@export var money_feed_resource : Resource
@export var tower_data_container : VBoxContainer
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
	buttons.append(tower_data_container.prio_forward_button)
	buttons.append(tower_data_container.prio_back_button)
	buttons.append(tower_data_container.upgrade_button)

func add_money_feed_label(amount : int) -> void:
	var money_feed_instance = money_feed_resource.instantiate()
	money_feed_instance.init(amount)
	money_feed_container.add_child(money_feed_instance)
	money_feed_container.move_child(money_feed_instance, 0)

#ONLY to be called from the player
func update_all(money : int, wave_at : int, tower_cost : int, wave_active : bool):
	money_label.text = "Money: " + str(money)
	wave_label.text = "Waves cleared: " + str(wave_at)
	
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
