extends Projectile

@export var tower_damage_mult : float = 1
@export var tower_projectile_speed_mult : float = 0.25
@export var tower_range_mult : float = 2

var theta : float

func init(t : Tower, d : int, cm : float, cc : float, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	$Sprite2D.play()
	
	var radius : float = r * tower_range_mult
	
	tower = t
	base_damage = d * tower_damage_mult
	crit_multiplier = cm
	crit_chance = cc
	speed = ps * tower_projectile_speed_mult
	remaining_pierces = 2
	
	position.x -= radius
	
	var time = (60 * PI * radius) / speed
	theta = PI / time
	
	#Rotation matrix fuckshit
	var aimprime_x = dir.x * cos(init_angle_offset) - dir.y * sin(init_angle_offset)
	var aimprime_y = dir.x * sin(init_angle_offset) + dir.y * cos(init_angle_offset)
	var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	
	direction = aimprime
	
	linear_velocity = direction * speed
	
	max_dist_from_tower = 9999999
	
func _physics_process(delta : float) -> void:
	super(delta)
	
	#Rotation matrix fuckshit
	var aimprime_x = linear_velocity.x * cos(theta) - linear_velocity.y * sin(theta)
	var aimprime_y = linear_velocity.x * sin(theta) + linear_velocity.y * cos(theta)
	var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	
	linear_velocity = aimprime * speed
	
	$Sprite2D.look_at(global_position + aimprime)
	$Sprite2D.rotate(PI / 2)
	
	

func _on_hitbox_area_entered(area : Area2D) -> void:
	super(area)
	
	#Ensure bird never runs out of pierces
	remaining_pierces += 1
