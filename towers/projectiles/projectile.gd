extends RigidBody2D
class_name Projectile

@export var init_angle_offset : float = 0

var tower : Tower
var base_damage : int
var crit_multiplier : float
var remaining_pierces : int
var speed : float
var direction : Vector2
var rotation_speed : float
var crit_chance : float
var max_dist_from_tower : float

signal damage_dealt(amount : int, crit : int, pos : Vector2)

func _ready() -> void:
	linear_velocity = direction * speed
	$Sprite2D.look_at(position + direction)
	$Sprite2D.rotate(PI / 2)

func _physics_process(delta : float) -> void:
	if position.distance_to(tower.position) > max_dist_from_tower:
		queue_free()
	
	$Sprite2D.rotate(rotation_speed)

func init(t : Tower, d : int, cm : float, cc : float, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	tower = t
	base_damage = d
	crit_multiplier = cm
	#crit_level = cl
	crit_chance = cc
	speed = ps
	remaining_pierces = p
	position = pos
	
	$Sprite2D.texture = t.get_projectile_texture()
	
	#Rotation matrix fuckshit
	var aimprime_x = dir.x * cos(init_angle_offset) - dir.y * sin(init_angle_offset)
	var aimprime_y = dir.x * sin(init_angle_offset) + dir.y * cos(init_angle_offset)
	var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	
	rotation_speed = (PI / 60) * t.get_projectile_rotation_speed()
	
	direction = aimprime
	
	#damage *= cm ** cl
	max_dist_from_tower = r * 2

func roll_crit() -> int:
	var crit_level = 0
	var challenge_failed = false
	var i = 1
	
	while not challenge_failed:
		var challenge_num = randf_range(0, 100)
		if crit_chance / i >= challenge_num:
			crit_level += 1
			i += 1
		else:
			challenge_failed = true
	
	return crit_level

func _on_hitbox_area_entered(area : Area2D) -> void:
	var target = area.get_parent()
	
	var crit_level = roll_crit()
	
	var damage = base_damage * (crit_multiplier ** crit_level)
	#Calculate damage dealt and increment tower's total damage dealt
	#Does not count overkill damage
	#if damage > target.hp:
		##Only deal damage if target is not already dead, throw an error otherwise
		##Likely occurs because multiple projectiles hit an enemy in the same frame they hit 0 hp
		##Maybe fix at some point idk
		#if target.hp <= 0:
			#push_error("Dealing damage to target with hp = " + str(target.hp))
		#else:
			#damage_dealt.emit(target.hp, is_crit, global_position)
			#print_debug("emitted with amount = " + str(target.hp))
	#else:
		##get_parent().total_damage_dealt += damage
		#damage_dealt.emit(damage, is_crit, global_position)
		#print_debug("emitted with amount = " + str(damage))
	#Counts overkill damage
	if target.hp > 0:
		damage_dealt.emit(damage, crit_level, global_position)
		
		target.take_damage(damage)
	
		if remaining_pierces <= 0:
			queue_free()
		remaining_pierces -= 1
	else:
		push_error("Dealing damage to target with hp = " + str(target.hp))
	
	
