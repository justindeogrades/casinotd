extends PanelContainer

@export var accept_button : Button
@export var reroll_button : Button
@export var ban_button : Button
@export var rarity_label : Label
@export var name_label : Label
@export var description_label : Label
@export var text_rect : TextureRect

var tower : Tower
var reroll_cost : int
var ban_cost : int
var can_ban : bool

signal accepted(tower : Tower)
signal rerolled(cost : int)
signal banned(tower : Tower)

func init(t : Tower, r : int, b : int, c : bool) -> void:
	tower = t
	reroll_cost = r
	ban_cost = b
	can_ban = c
	
	var rarity = tower.get_rarity()
	rarity_label.text = G.rarity_to_string(rarity).to_upper() + " TOWER"
	rarity_label.label_settings.font_color = G.rarity_to_colour(rarity)
	
	name_label.text = tower.get_tower_name()
	description_label.text = tower.get_tower_description()
	text_rect.texture = tower.get_portrait_texture()
	reroll_button.text = "Reroll - $" + str(reroll_cost) 
	ban_button.text = "Ban - $" + str(ban_cost)
	

func _on_accept_button_pressed() -> void:
	accepted.emit(tower)


func _on_reroll_button_pressed() -> void:
	rerolled.emit(reroll_cost)


func _on_ban_button_pressed() -> void:
	if can_ban:
		banned.emit(tower)
	else:
		ban_button.text = "Can't ban all towers of a rarity"
