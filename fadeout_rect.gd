extends ColorRect

signal faded

func _ready() -> void:
	$AnimationPlayer.play("fade")

func end() -> void:
	faded.emit()
	queue_free()
