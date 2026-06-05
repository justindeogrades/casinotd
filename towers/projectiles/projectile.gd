extends RigidBody2D
class_name Projectile

@export var init_angle_offset : float = 0

var tower : Tower
var damage : float
var remaining_pierces : int
var speed : float
var direction : Vector2
var crit_level : int
var max_dist_from_tower : float

signal damage_dealt(amount : int, crit : int, pos : Vector2)

func _ready() -> void:
	linear_velocity = direction * speed

func _physics_process(delta : float) -> void:
	if position.distance_to(tower.position) > max_dist_from_tower:
		queue_free()

func init(t : Tower, d : int, cm : float, cl : int, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	tower = t
	damage = d
	crit_level = cl
	speed = ps
	remaining_pierces = p
	position = pos
	
	#Rotation matrix fuckshit
	var aimprime_x = dir.x * cos(init_angle_offset) - dir.y * sin(init_angle_offset)
	var aimprime_y = dir.x * sin(init_angle_offset) + dir.y * cos(init_angle_offset)
	var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	
	direction = aimprime
	
	damage *= cm ** cl
	max_dist_from_tower = r * 2

func _on_hitbox_area_entered(area : Area2D) -> void:
	var target = area.get_parent()
	
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
	else:
		push_error("Dealing damage to target with hp = " + str(target.hp))
	
	target.take_damage(damage)
	
	if remaining_pierces <= 0:
		queue_free()
	remaining_pierces -= 1
