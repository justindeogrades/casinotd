extends Node

@export_category("Hits")
@export var hit_sfx : AudioStreamPlayer
@export var crit_sfx : AudioStreamPlayer
@export var doublecrit_sfx : AudioStreamPlayer
@export var triplecrit_sfx : AudioStreamPlayer
@export var multicrit_sfx : AudioStreamPlayer
@export_category("Selecteds")
@export var common_selected_sfx : AudioStreamPlayer
@export var uncommon_selected_sfx : AudioStreamPlayer
@export var rare_selected_sfx : AudioStreamPlayer
@export var legendary_selected_sfx : AudioStreamPlayer
@export_category("Cards")
@export var card_deal_sfx : AudioStreamPlayer
@export var card_hover_sfx : AudioStreamPlayer
@export var card_sparkle_sfx : AudioStreamPlayer
@export_category("Buttons")
@export var button_hover_sfx : AudioStreamPlayer
@export var button_pressed_sfx : AudioStreamPlayer
@export_category("Other")
@export var slot_machine_sfx : AudioStreamPlayer

@onready var hits : Array[AudioStreamPlayer] = [hit_sfx, crit_sfx, doublecrit_sfx, triplecrit_sfx, multicrit_sfx]
@onready var selecteds : Array[AudioStreamPlayer] = [common_selected_sfx, uncommon_selected_sfx, rare_selected_sfx, legendary_selected_sfx]
