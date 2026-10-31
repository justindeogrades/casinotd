extends Node

const SAVE_LOCATION = "user://triplecritcasinosavefile.txt"

const NULL_DATA : Dictionary = {
	"best_waves_survived" : 0,
	"best_total_damage_dealt" : 0,
	"best_total_money_earned" : 0,
	"best_mvp_level" : 0,
	"best_mvp_name" : " ",
	"best_mvp_damage" : 0
}

func save_file(new_data : Dictionary) -> void:
	var file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	file.store_var(new_data.duplicate())
	file.close()

func load_file() -> Dictionary:
	if FileAccess.file_exists(SAVE_LOCATION):
		var file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
		return file.get_var()
	push_error("Save file location does not exist!")
	return NULL_DATA

func clear_save_data() -> void:
	save_file(NULL_DATA)
