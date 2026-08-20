extends Button

@export var anim_player : AnimationPlayer
@export var value_labels : Array[Label]
@export var suit_rects : Array[TextureRect]
@export var center_suit_rect : TextureRect
@export var upgrade_label : Label
@export var particles : GPUParticles2D

var face : int

signal entered

var mouseovered : bool = false

func enter() -> void:
	AudioManager.card_deal_sfx.play()
	if face == G.face.ACE:
		AudioManager.card_sparkle_sfx.play()
		particles.modulate = G.rarity_to_colour(face)
		particles.amount_ratio = 1
	else:
		particles.amount_ratio = 0
	
	particles.global_position = global_position + Vector2(200, 900)
	anim_player.play("enter")

func emit_entered() -> void:
	#print_debug(modulate.a)
	entered.emit()

func enable() -> void:
	disabled = false
	if mouseovered:
		AudioManager.card_hover_sfx.play()
		anim_player.play("select")

func _on_mouse_entered() -> void:
	if not disabled:
		AudioManager.card_hover_sfx.play()
		anim_player.play("select")
	mouseovered = true




func _on_mouse_exited() -> void:
	if not disabled:
		anim_player.play("deselect")
	mouseovered = false
