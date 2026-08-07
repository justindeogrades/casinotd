extends Label

@export var positive_col : Color
@export var negative_col : Color

@export var anim_player : AnimationPlayer

func init(amount : int) -> void:
	var sign_char : String
	
	if amount >= 0:
		sign_char = "+"
		label_settings.font_color = positive_col
	else:
		sign_char = ""
		label_settings.font_color = negative_col
	
	text = sign_char + str(amount)
	
	anim_player.play("enter_and_exit")
