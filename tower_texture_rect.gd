extends TextureRect

signal anim_completed

func emit_anim_completed() -> void:
	anim_completed.emit()
