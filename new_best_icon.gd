extends Control

@export var resize_player : AnimationPlayer
@export var flash_player : AnimationPlayer

func _ready() -> void:
	flash_player.play("flash")
	resize_player.play("resize")
