extends Node2D

@export var crit_label : Label
@export var damage_label : Label
@export var anim_player : AnimationPlayer

var crit_col : Color = Color.YELLOW

func init(amount : int, crit_level : int, pos : Vector2):
	damage_label.text = str(amount)
	if crit_level >= 1:
		#Set colours to crit colour, then decide text based on crit level
		crit_label.set("theme_override_colors/font_color", crit_col)
		damage_label.set("theme_override_colors/font_color", crit_col)
		if crit_level == 1:
			crit_label.text = "CRIT!"
		elif crit_level == 2:
			crit_label.text = "DOUBLECRIT!!"
		elif crit_level == 3:
			crit_label.text = "TRIPLECRIT!!!"
		else:
			crit_label.text = str(crit_level) + "x CRIT!!!"
	global_position = pos
	anim_player.play("rise")
	
	set_z_index(2 + crit_level)
