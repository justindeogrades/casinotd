extends PanelContainer

@export var accept_button : Button
@export var reroll_button : Button
@export var name_label : Label
@export var description_label : Label
@export var text_rect : TextureRect

var tower : Tower
var reroll_cost : float

signal accepted(tower : Tower)
signal rerolled

func init(t : Tower, r : int) -> void:
	tower = t
	reroll_cost = r
	name_label.text = tower.get_tower_name()
	description_label.text = tower.get_tower_description()
	text_rect.texture = tower.get_sprite_texture()
	reroll_button.text = "Reroll - $" + str(reroll_cost) 

func _on_accept_button_pressed() -> void:
	accepted.emit(tower)


func _on_reroll_button_pressed() -> void:
	rerolled.emit(reroll_cost)
