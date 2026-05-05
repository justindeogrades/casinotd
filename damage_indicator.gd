extends Node2D

@export var damage_label : Label
@export var anim_player : AnimationPlayer

var crit_col : Color = Color.YELLOW

func init(amount : int, is_crit : bool, pos : Vector2):
	damage_label.text = str(amount)
	if is_crit:
		#damage_label.font_color = crit_col
		damage_label.set("theme_override_colors/font_color", crit_col)
	global_position = pos
	anim_player.play("rise")
