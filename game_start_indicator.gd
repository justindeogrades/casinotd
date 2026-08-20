extends Control

@export var game_start_label : Label
@export var life_timer : Timer
@export var flash_player : AnimationPlayer

var col_a = Color.from_rgba8(196, 36, 48)
var col_b = Color.WHITE

var texts : Array[String] = [
	"TIME TO COOK",
	"WE'RE GOING ALL IN"
]

func _ready() -> void:
	#Choose random text to display
	var rand_index = randi_range(0, texts.size() - 1)
	game_start_label.text = texts[rand_index]
	
	flash_player.play("flash")
	

func _on_life_timer_timeout() -> void:
	queue_free()
