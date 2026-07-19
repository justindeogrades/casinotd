extends Projectile

@export var hitbox_shape : CollisionShape2D

var exploding : bool = false

#func init(t : Tower, d : int, cm : float, cc : float, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	#tower = t
	#damage = d
	#crit_level = cl
	#speed = ps
	#remaining_pierces = p
	#position = pos
	#
	#
	##Rotation matrix fuckshit
	#var aimprime_x = dir.x * cos(init_angle_offset) - dir.y * sin(init_angle_offset)
	#var aimprime_y = dir.x * sin(init_angle_offset) + dir.y * cos(init_angle_offset)
	#var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	#
	#rotation_speed = (PI / 60) * t.get_projectile_rotation_speed()
	#
	#direction = aimprime
	#
	#damage *= cm ** cl
	#max_dist_from_tower = r * 2

func _on_hitbox_area_entered(area : Area2D) -> void:
	var target = area.get_parent()
	
	var crit_level = roll_crit()
	
	var damage = base_damage * (crit_multiplier ** crit_level)
	
	if not target.is_dying():
		if not exploding:
			exploding = true
			hitbox_shape.shape.radius = 120
			linear_velocity = Vector2.ZERO
			$Sprite2D.play()
			$Sprite2D.animation_finished.connect(_on_animation_finished)
		
		if exploding:
			if target.hp > 0:
				damage_dealt.emit(damage, crit_level, global_position)
				target.take_damage(damage)

func _on_animation_finished() -> void:
	queue_free()
