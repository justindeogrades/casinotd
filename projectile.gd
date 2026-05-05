extends RigidBody2D

var damage : float
var remaining_pierces : int
var speed : float
var direction : Vector2

func _ready() -> void:
	linear_velocity = direction * speed

func _on_hitbox_area_entered(area : Area2D) -> void:
	var target = area.get_parent()
	
	#Calculate damage dealt and increment tower's total damage dealt
	#Does not count overkill damage
	if damage > target.hp:
		get_parent().total_damage_dealt += target.hp
	else:
		get_parent().total_damage_dealt += damage
		
	target.take_damage(damage)
	
	if remaining_pierces <= 0:
		queue_free()
	remaining_pierces -= 1
