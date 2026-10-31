extends PanelContainer

@export var game_over_label : Label
@export var stat_labels : Array[Label]
@export var run_data_labels : Array[Label]
@export var best_data_labels : Array[Label]
@export var new_best_icons : Array[Control]
@export var confirm_button : Button

enum {
	WAVES_SURVIVED,
	DAMAGE_DEALT,
	MONEY_EARNED,
	MVP_LEVEL,
	MVP_NAME,
	MVP_DAMAGE
}

var win : bool = false

signal confirmed(victory : bool)

func init(victory: bool, waves_survived : int, damage_dealt : int, money_earned : int, mvp : Tower) -> void:
	var best_dict : Dictionary = SaveManager.load_file()
	
	var run_data : Array
	if mvp != null:
		run_data = [
			waves_survived,
			damage_dealt,
			money_earned,
			mvp.level,
			mvp.tower_name,
			mvp.total_damage_dealt
		]
	else:
		run_data = [
			waves_survived,
			damage_dealt,
			money_earned,
			0,
			" ",
			0
		]
	var best_data = [
		best_dict["best_waves_survived"],
		best_dict["best_total_damage_dealt"],
		best_dict["best_total_money_earned"],
		best_dict["best_mvp_level"],
		best_dict["best_mvp_name"],
		best_dict["best_mvp_damage"]
	]
	
	win = victory
	if victory:
		game_over_label.text = "You win! (get a job)"
	else:
		game_over_label.text = "Game over (you suck 😂🫵)"
	
	var new_best_visibility : Array[bool] = get_new_bests(run_data, best_data)
	for i in new_best_icons.size():
		if new_best_visibility[i]:
			new_best_icons[i].modulate.a = 1
		else:
			new_best_icons[i].modulate.a = 0
	
	#if mvp != null:
		#run_mvp_data_string = "Level " + str(mvp.level) + " " + mvp.get_tower_name() + " with " + str(mvp.total_damage_dealt) + " damage dealt"
	#else:
		#run_mvp_data_string = "You didn't even have any towers lmao"
	
	#if best_data[MVP_NAME] != " ":
		#best_mvp_data_string = "Level " + str(best_data["best_mvp_level"]) + " " + best_data["best_mvp_name"] + " with " + str(best_data["best_mvp_damage_dealt"]) + " damage dealt"
	#else:
		#best_mvp_data_string = " "
	
	init_label_array(run_data_labels, run_data)
	init_label_array(best_data_labels, best_data)
	
	#var format_stat_names_string = "%s\n%s\n%s\n%s"
	#stat_names_label.text = format_stat_names_string % [
	#"Waves survived:",
	#"Total damage dealt:",
	#"Total money earned:",
	#"MVP:",
	#]
	#var format_run_data_string = "%.f\n%.f\n%.f\n%s"
	#run_data_label.text = format_run_data_string % [
	#waves_survived,
	#damage_dealt,
	#money_earned,
	#run_mvp_data_string,
	#]
	#var format_best_data_string = "%.f\n%.f\n%.f\n%s"
	##var format_best_data_string = "%s%.f\n%s%.f\n%s%.f\n%s"
	#best_data_label.text = format_best_data_string % [
		##"Best: ", str(best_data["best_waves_survived"]),
		##"Best: ", str(best_data["best_total_damage_dealt"]),
		##"Best: ", str(best_data["best_total_money_earned"]),
		##"Best: " + best_mvp_data_string
		#best_data["best_waves_survived"],
		#best_data["best_total_damage_dealt"],
		#best_data["best_total_money_earned"],
		#"Best: " + best_mvp_data_string
	#]
	
	save_new_best_data(run_data, best_data)

func init_label_array(label_array : Array[Label], data : Array) -> void:
	label_array[WAVES_SURVIVED].text = str(data[WAVES_SURVIVED])
	label_array[DAMAGE_DEALT].text = str(data[DAMAGE_DEALT])
	label_array[MONEY_EARNED].text = str(data[MONEY_EARNED])
	if data[MVP_NAME] != " ":
		label_array[3].text = "Level " + str(data[MVP_LEVEL]) + " " + data[MVP_NAME] + " with " + str(data[MVP_DAMAGE]) + " damage dealt"
	else:
		label_array[3].text = "None"

func get_new_bests(run_data : Array, best_data : Array) -> Array[bool]:
	var new_bests : Array[bool]
	
	if run_data[WAVES_SURVIVED] > best_data[WAVES_SURVIVED]:
		new_bests.append(true)
	else:
		new_bests.append(false)
	
	if run_data[DAMAGE_DEALT] > best_data[DAMAGE_DEALT]:
		new_bests.append(true)
	else:
		new_bests.append(false)
	
	if run_data[MONEY_EARNED] > best_data[MONEY_EARNED]:
		new_bests.append(true)
	else:
		new_bests.append(false)
	
	if run_data[MVP_DAMAGE] > best_data[MVP_DAMAGE]:
		new_bests.append(true)
	else:
		new_bests.append(false)
	
	return new_bests
	
func save_new_best_data(run_data : Array, best_data : Array):
	var new_dict : Dictionary
	
	if run_data[WAVES_SURVIVED] > best_data[WAVES_SURVIVED]:
		new_dict["best_waves_survived"] = run_data[WAVES_SURVIVED]
	else:
		new_dict["best_waves_survived"] = best_data[WAVES_SURVIVED]
	
	if run_data[DAMAGE_DEALT] > best_data[DAMAGE_DEALT]:
		new_dict["best_total_damage_dealt"] = run_data[DAMAGE_DEALT]
	else:
		new_dict["best_total_damage_dealt"] = best_data[DAMAGE_DEALT]
	
	if run_data[MONEY_EARNED] > best_data[MONEY_EARNED]:
		new_dict["best_total_money_earned"] = run_data[MONEY_EARNED]
	else:
		new_dict["best_total_money_earned"] = best_data[MONEY_EARNED]
	
	if run_data[MVP_DAMAGE] > best_data[MVP_DAMAGE]:
		new_dict["best_mvp_level"] = run_data[MVP_LEVEL]
		new_dict["best_mvp_name"] = run_data[MVP_NAME]
		new_dict["best_mvp_damage"] = run_data[MVP_DAMAGE]
	else:
		new_dict["best_mvp_level"] = best_data[MVP_LEVEL]
		new_dict["best_mvp_name"] = best_data[MVP_NAME]
		new_dict["best_mvp_damage"] = best_data[MVP_DAMAGE]
	
	SaveManager.save_file(new_dict)

func _on_confirm_button_pressed() -> void:
	confirmed.emit(win)
