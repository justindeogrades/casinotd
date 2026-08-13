extends Mob

@export var dmg_1_sprite : Sprite2D
@export var dmg_2_sprite : Sprite2D
@export var dmg_3_sprite : AnimatedSprite2D
@export var dmg_4_sprite : Sprite2D
@export var dmg_5_sprite : Sprite2D

func take_damage(damage : int) -> void:
	super(damage)
	
	if hp < 0.25 * max_hp:
		dmg_3_sprite.visible = true
		dmg_3_sprite.play()
		dmg_4_sprite.visible = false
	elif hp < 0.5 * max_hp:
		dmg_2_sprite.visible = true
		dmg_5_sprite.visible = true
	elif hp < 0.75 * max_hp:
		dmg_1_sprite.visible = true

func death() -> void:
	super()
	
	dmg_1_sprite.visible = false
	dmg_2_sprite.visible = false
	dmg_3_sprite.visible = false
