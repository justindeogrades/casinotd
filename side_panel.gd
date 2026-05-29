extends PanelContainer

@export var money_label : Label
@export var lives_label : Label
@export var tower_data_container : VBoxContainer
@export var quick_spins_box : CheckBox
@export var buy_button : Button
@export var next_wave_button : Button

var player : Node

func _ready() -> void:
	player = get_parent().get_parent()
	tower_data_container.player = player
	
	refresh_buy_button()

func refresh_buy_button() -> void:
	buy_button.text = "Buy tower - $" + str(player.tower_cost)

func set_tower_data_container_visible(vis : bool) -> void:
	tower_data_container.visible = vis
