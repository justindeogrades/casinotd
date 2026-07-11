extends Tower

@export var anim_sprite : AnimatedSprite2D

func rotate_sprite_to_target(target : Vector2) -> void:
	anim_sprite.look_at(target)
	anim_sprite.rotate(PI / 2)

func get_sprite_texture() -> Texture2D:
	var frame_index : int = anim_sprite.get_frame()
	var animation_name : String = anim_sprite.animation
	var sprite_frames: SpriteFrames = anim_sprite.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)
	
	return current_texture
