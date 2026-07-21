extends Node2D

@export var portrait_sprite : Sprite2D
@export var back_sprite : Sprite2D
@export var backsprites : Array[Texture2D]
@export var hitbox : CollisionShape2D

var tower : Tower
var speed : float
var passed_mid : bool = false

signal mid_reached(s : Node2D)
signal end_reached(s : Node2D)

func _ready() -> void:
	#Centers the symbols
	position.x = get_viewport_rect().size.x / 2

func _process(delta: float) -> void:
	position.y += speed
	
	if position.y >= (get_viewport_rect().size.y / 2) - 250 and not passed_mid:
		passed_mid = true
		mid_reached.emit(self)

func init(s : float, t : Tower, ypos) -> void:
	#anim_player.play("rotate", -1, speed)
	speed = s
	tower = t
	portrait_sprite.texture = tower.get_portrait_texture()
	#back_sprite.texture = backsprites[tower.rarity]
	back_sprite.modulate = G.rarity_to_colour(tower.get_rarity())
	position.y = ypos
	
	#Ensures it appears in front of towers
	set_z_index(2)

#Made redundant
#Called when the symbol reaches the point at which the next symbol should be created
#func mid() -> void:
	#mid_reached.emit()

func end() -> void:
	end_reached.emit(self)
	queue_free()

func set_speed(s : float) -> void:
	#anim_player.speed_scale = speed
	speed = s

func get_tower() -> Tower:
	return tower
