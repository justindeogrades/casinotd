extends PanelContainer

@export var game_over_label : Label
@export var stat_names_label : Label
@export var stat_data_label : Label
@export var confirm_button : Button

var win : bool = false

signal confirmed(victory : bool)

func init(victory: bool, waves_survived : int, damage_dealt : int, money_earned : int, mvp : Tower) -> void:
	win = victory
	if victory:
		game_over_label.text = "You win!"
	else:
		game_over_label.text = "Game over (you suck 😂🫵)"
	
	var mvp_data_string : String
	
	if mvp != null:
		mvp_data_string = "Level " + str(mvp.level) + " " + mvp.get_tower_name() + " with " + str(mvp.total_damage_dealt) + " damage dealt"
	else:
		mvp_data_string = "You didn't even have any towers lmao"
	
	var format_stat_names_string = "%s\n%s\n%s\n%s"
	stat_names_label.text = format_stat_names_string % [
	"Waves survived:",
	"Total damage dealt:",
	"Total money earned:",
	"MVP:",
	]
	var format_stat_data_string = "%.f\n%.f\n%.f\n%s"
	stat_data_label.text = format_stat_data_string % [
	waves_survived,
	damage_dealt,
	money_earned,
	mvp_data_string,
	]


func _on_confirm_button_pressed() -> void:
	confirmed.emit(win)
