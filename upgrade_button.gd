extends Button

@export var anim_player : AnimationPlayer



func _on_mouse_entered() -> void:
	anim_player.play("select")




func _on_mouse_exited() -> void:
	anim_player.play("deselect")
