extends Button

@export var anim_player : AnimationPlayer

signal entered

func enter() -> void:
	anim_player.play("enter")

func emit_entered() -> void:
	entered.emit()



func _on_mouse_entered() -> void:
	if not disabled:
		anim_player.play("select")
		print_debug("mouseovered and enabled")
	else:
		print_debug("mouseovered and disabled")




func _on_mouse_exited() -> void:
	if not disabled:
		anim_player.play("deselect")
