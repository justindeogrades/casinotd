extends Button

@export var anim_player : AnimationPlayer
@export var value_labels : Array[Label]

signal entered

var mouseovered : bool = false

func enter() -> void:
	anim_player.play("enter")

func emit_entered() -> void:
	#print_debug(modulate.a)
	entered.emit()

func enable() -> void:
	disabled = false
	if mouseovered:
		anim_player.play("select")

func _on_mouse_entered() -> void:
	if not disabled:
		anim_player.play("select")
	mouseovered = true




func _on_mouse_exited() -> void:
	if not disabled:
		anim_player.play("deselect")
	mouseovered = false
