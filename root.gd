extends Node

@export var main_menu : Resource
@export var map : Resource

var main_menu_instance : Control
var map_instance : Node2D

func _ready() -> void:
	init_main_menu()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		init_main_menu()

func init_main_menu() -> void:
	remove_all_children()
	
	main_menu_instance = main_menu.instantiate()
	add_child(main_menu_instance)
	
	main_menu_instance.play_button.pressed.connect(_on_play_button_pressed)
	main_menu_instance.quit_button.pressed.connect(_on_quit_button_pressed)

func init_map() -> void:
	remove_all_children()
	
	map_instance = map.instantiate()
	add_child(map_instance)
	
	#map_instance/$Player.game_over.connect(_on_game_over)
	map_instance.get_node("Player").game_over.connect(_on_game_over)

func remove_all_children() -> void:
	for i in get_children():
		i.queue_free()

func _on_play_button_pressed() -> void:
	init_map()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_game_over() -> void:
	init_main_menu()
