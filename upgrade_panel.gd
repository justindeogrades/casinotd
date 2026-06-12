extends PanelContainer

#CHANGING THE NAME OF THE ARRAY RESETS THE EXPORT
@export var upgrade_button : Array[Button]
@export var reroll_button : Button

var upgrade_data : Array[Array]

#Expressed in percentages (100 times proportion)
var face_probabilities : Array[float] = [50, 30, 15, 5]

var tower_to_upgrade : Tower
var upgrade_option : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

var reroll_cost : int
var rerolls_remaining : int

signal upgrade_selected
signal reroll_pressed

func _ready() -> void:
	initialize_buttons()
	initialize_upgrade_data_array()

#func _process(delta: float) -> void:
	#if visible:
		#print_debug("processing")

func initialize_upgrade_data_array() -> void:
	for i in G.att:
		upgrade_data.append([])
	
	upgrade_data[G.att.DAMAGE] = [8, 12, 18, 30]
	upgrade_data[G.att.ATTACK_SPEED] = [15, 25, 40, 58]
	upgrade_data[G.att.RANGE] = [10, 15, 20, 30]
	upgrade_data[G.att.CRIT_CHANCE] = [5, 8, 12, 20]
	upgrade_data[G.att.CRIT_MULT] = [1, 1.4, 2, 2.8]
	upgrade_data[G.att.PROJ_SPEED] = [200, 220, 250, 300]
	upgrade_data[G.att.PROJ_COUNT] = [1, 1, 1, 2]
	upgrade_data[G.att.PIERCE] = [1, 1, 1, 2]

func initialize_buttons() -> void:
	for i in upgrade_button:
		i.pressed.connect(_on_upgrade_selected.bind(i))
	reroll_button.pressed.connect(_on_reroll_button_pressed)

func generate_upgrade_options() -> void:
	var upgrade_vector = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
	
	#Ensure two cards cannot be the same
	while true:
		for i in [0, 1, 2]:
			upgrade_vector[i] = choose_upgrade()
		
		if upgrade_vector[0].x != upgrade_vector[1].x:
			if upgrade_vector[0].x != upgrade_vector[2].x:
				if upgrade_vector[1].x != upgrade_vector[2].x:
					break
	
	for i in [0, 1, 2]:
		var att = upgrade_vector[i].x
		var att_string = attribute_to_string(att)
		var face = upgrade_vector[i].y
		var face_string = face_to_string(face)
		var amount = upgrade_data[att][face]
		
		upgrade_button[i].text = face_string + " of " + att_string + ":\n+" + str(amount) + " " + att_string
		
		upgrade_option[i] = Vector2(att, amount)

func choose_upgrade() -> Vector2:
	#Uniform dist for attributes
	var att = randi_range(0, G.att.size() - 1)
	#Challenge no for face
	var face = roll_face()
	
	return Vector2(att, face)

func roll_face() -> int:
	var challenge = randi_range(0, 100)
	if challenge < face_probabilities[G.face.ACE]:
		return G.face.ACE
	if challenge < face_probabilities[G.face.ACE] + face_probabilities[G.face.KING]:
		return G.face.KING
	if challenge < face_probabilities[G.face.ACE] + + face_probabilities[G.face.KING] + face_probabilities[G.face.QUEEN]:
		return G.face.QUEEN
	return G.face.JACK

func refresh_reroll_button(with_new_tower : bool) -> void:
	if with_new_tower:
		rerolls_remaining = tower_to_upgrade.level
	reroll_cost = tower_to_upgrade.upgrade_cost * 0.2
	reroll_button.text = "Reroll - $" + str(reroll_cost) + " (" + str(rerolls_remaining) + " remaining)"

func _on_reroll_button_pressed() -> void:
	if rerolls_remaining > 0:
		rerolls_remaining -= 1
		reroll_pressed.emit()

func _on_upgrade_selected(b : Button) -> void:
	var button_index = upgrade_button.find(b)
	var att = upgrade_option[button_index].x
	var amount = upgrade_option[button_index].y
	tower_to_upgrade.level += 1
	upgrade_selected.emit(tower_to_upgrade, att, amount)
	#match button_index:
		#0:
			#upgrade_selected.emit(tower_to_upgrade, G.att.RANGE, 10) 
		#1:
			#upgrade_selected.emit(tower_to_upgrade, G.att.ATTACK_SPEED, 20) 
		#2:
			#upgrade_selected.emit(tower_to_upgrade, G.att.PIERCE, 1) 
		#_:
			#push_error("Button index out of bounds")

func attribute_to_string(att : int) -> String:
	match att:
		G.att.DAMAGE:
			return "Damage"
		G.att.ATTACK_SPEED:
			return "Attack Speed"
		G.att.RANGE:
			return "Range"
		G.att.CRIT_CHANCE:
			return "Crit Chance"
		G.att.CRIT_MULT:
			return "Crit Damage Multiplier"
		G.att.PROJ_SPEED:
			return "Projectile Speed"
		G.att.PROJ_COUNT:
			return "Projectile Count"
		G.att.PIERCE:
			return "Pierce"
		_:
			push_error("Attribute index out of bounds!")
			return "OOB Attribute error"

func face_to_string(face : int) -> String:
	match face:
		G.face.JACK:
			return "Jack"
		G.face.QUEEN:
			return "Queen"
		G.face.KING:
			return "King"
		G.face.ACE:
			return "Ace"
		_:
			push_error("face index out of bounds!")
			return "OOB face error"
