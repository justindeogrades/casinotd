extends Sprite2D

var tower : Tower

func init(t: Tower) -> void:
	tower = t
	texture = tower.get_sprite_texture()

func _process(delta: float) -> void:
	global_position = get_viewport().get_mouse_position()
	#queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, tower.attribute[G.att.RANGE], Color(0,0,0,0.2))
