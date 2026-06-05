extends Projectile

var exited_tower : bool = false

var theta : float = PI / 20
#var theta : float

func init(t : Tower, d : int, cm : float, cl : int, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	super(t, d, cm, cl, ps, p, r, dir, pos, dist)
	
	var time = (PI * dist) / (2 * speed / 60)
	theta = PI / time
	
	print_debug("dist: " + str(dist))
	print_debug("time: " + str(time))
	print_debug("theta: " + str(theta))

func _physics_process(delta : float) -> void:
	super(delta)
	
	##Rotation matrix fuckshit
	#direction.x = direction.x * cos(theta) - direction.y * sin(theta)
	#direction.y = direction.x * sin(theta) + direction.y * cos(theta)
	#
	#linear_velocity = direction.normalized() * speed
	
	#Rotation matrix fuckshit
	var aimprime_x = linear_velocity.x * cos(theta) - linear_velocity.y * sin(theta)
	var aimprime_y = linear_velocity.x * sin(theta) + linear_velocity.y * cos(theta)
	var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
	
	linear_velocity = aimprime * speed
	
	#rotate(theta)
	
	#rotation += 0
	
	#print_debug(rotation)
	#print_debug(global_rotation)

func _on_tower_box_area_entered(area: Area2D) -> void:
	if exited_tower:
		queue_free()
func _on_tower_box_area_exited(area: Area2D) -> void:
	exited_tower = true
