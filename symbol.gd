extends Node2D

@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

var tower_preload = preload("res://towers/scenes/common_tower.tscn")
var tower : Tower = tower_preload.instantiate()

signal mid_reached
signal end_reached(s : Node2D)

func _ready() -> void:
	sprite.texture = tower.get_sprite_texture()
	scale.y = 0

#func _process(delta: float) -> void:
	#print_debug(scale.y)

func init(speed : float) -> void:
	#sprite.texture = texture
	anim_player.play("rotate", -1, speed)

#Called when the symbol reaches the point at which the next symbol should be created
func mid() -> void:
	mid_reached.emit()

func end() -> void:
	end_reached.emit(self)
	queue_free()

func set_speed(speed : float) -> void:
	anim_player.speed_scale = speed

func get_tower() -> Tower:
	return tower
