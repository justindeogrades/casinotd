extends Node2D

@export var crit_label : Label
@export var damage_label : Label
@export var anim_player : AnimationPlayer
@export var particles : GPUParticles2D

var crit_col : Color = Color.from_rgba8(255, 235, 87)
var doublecrit_col : Color = Color.from_rgba8(255, 80, 0)
var triplecrit_col : Color = Color.from_rgba8(196, 36, 48)

func init(amount : int, crit_level : int, pos : Vector2):
	damage_label.text = str(amount)
	if crit_level >= 1:
		var col : Color
		
		if crit_level == 1:
			AudioManager.crit_sfx.play()
			col = crit_col
			crit_label.text = "CRIT!"
		elif crit_level == 2:
			AudioManager.doublecrit_sfx.play()
			col = doublecrit_col
			crit_label.text = "DOUBLECRIT!!"
		elif crit_level == 3:
			AudioManager.triplecrit_sfx.play()
			col = triplecrit_col
			crit_label.text = "TRIPLECRIT!!!"
		else:
			AudioManager.multicrit_sfx.play()
			col = triplecrit_col
			crit_label.text = str(crit_level) + "x CRIT!!!"
		
		#Only particles on crit
		particles.emitting = true
		particles.modulate = col
		
		#Set colours to crit colour, then decide text based on crit level
		crit_label.set("theme_override_colors/font_color", col)
		damage_label.set("theme_override_colors/font_color", col)
	else:
		AudioManager.hit_sfx.play()
	global_position = pos
	anim_player.play("rise")
	
	set_z_index(2 + crit_level)
