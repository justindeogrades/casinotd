class_name Tower
extends Node2D

@export_category("Attributes")
@export var attribute : Array[float] = [
	30, #Damage
	100, #Attack speed
	100, #Range
	10, #Crit chance (percent)
	3, #Crit damage multiplier
	1000, #Projectile speed
	1, #Projectile count
	0 #Pierce
]
@export var tower_name : String = "Tower"
#Angle between projectiles
@export var angle_between_projectiles : float = PI / 12
@export var rarity : int
@export_category("Children")
@export var sprite : Sprite2D
@export var range_area : Area2D
@export var range_collision : CollisionShape2D
@export var cooldown_timer : Timer
@export var projectile : RigidBody2D
@export var mousebox : Area2D
@export var data_panel_button : Button

signal clicked(tower : Tower)
signal damage_dealt(amount : int, crit : bool, pos : Vector2)

#@onready var cooldown_seconds = 50 / attack_speed
@onready var cooldown_seconds = 50 / attribute[G.att.ATTACK_SPEED]

var projectile_preload = preload("res://projectile.tscn")

var level : int = 1
var mobs_in_range : Array[Mob]
var target_prio : int = G.prio.FIRST
var kills : int = 0
var total_damage_dealt : float = 0
var upgrade_cost : int = 10

#signal mouse_hovering
var mouseovered : bool = false

var range_indicator_visible : bool = false

func _ready() -> void:
	#Make a unique shape so updating it doesn't update all shapes
	#range_collision.shape = range_collision.shape.duplicate(true)
	update_range()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouseovered:
		clicked.emit(self)

func _process(delta: float) -> void:
	#Targeting and shooting
	if not mobs_in_range.is_empty():
		var target = get_target(target_prio)
		var aim_direction = (target.global_position - position).normalized()
		if cooldown_timer.is_stopped():
			#Iterate once per projectile count, offsetting the angle a little every shot
			for i in attribute[G.att.PROJ_COUNT]:
				var theta = angle_between_projectiles
				
				#Sequence asubn where an = (n+1)/2 if n is odd, and an = -n/2 if n is even
				#Case i is even
				if int(i) % 2 == 0:
					theta *= -i / 2
				#Case i is odd
				else:
					theta *= (i + 1) / 2
				#if i == 0:
					#theta = 0
				#else:
					#if int(i) % 2 == 0:
						#theta *= -(i - 1)
					#else:
						#theta *= i
				#Rotation matrix fuckshit
				var aimprime_x = aim_direction.x * cos(theta) - aim_direction.y * sin(theta)
				var aimprime_y = aim_direction.x * sin(theta) + aim_direction.y * cos(theta)
				var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
				
				spawn_projectile(aimprime)
			cooldown_timer.start(cooldown_seconds)
	else:
		pass

func spawn_projectile(aim_direction : Vector2) -> void:
	var is_crit = roll_crit()
	
	#var projectile_instance = projectile_preload.instantiate()
	var projectile_instance = load("res://projectile.tscn").instantiate()
	
	#projectile_instance.damage = damage
	#if is_crit:
		#projectile_instance.damage *= crit_damage_multiplier
	#projectile_instance.speed = projectile_speed
	#projectile_instance.remaining_pierces = projectile_pierce
	#projectile_instance.direction = aim_direction
	
	projectile_instance.damage = attribute[G.att.DAMAGE]
	if is_crit:
		projectile_instance.is_crit = true
		projectile_instance.damage *= attribute[G.att.CRIT_MULT]
	projectile_instance.speed = attribute[G.att.PROJ_SPEED]
	projectile_instance.remaining_pierces = attribute[G.att.PIERCE]
	projectile_instance.direction = aim_direction
	
	projectile_instance.damage_dealt.connect(_on_projectile_damage_dealt)
	
	add_child(projectile_instance)

func roll_crit() -> bool:
	var challenge_num = randf_range(0, 100)
	
	if attribute[G.att.CRIT_CHANCE] >= challenge_num:
		return true
	return false

func upgrade_attribute(att : int, amount : float) -> void:
	attribute[att] += amount
	update_cooldown()
	update_range()

func _on_range_area_entered(area: Area2D) -> void:
	mobs_in_range.append(area.get_parent())

func _on_range_area_exited(area: Area2D) -> void:
	mobs_in_range.erase(area.get_parent())

func get_target(prio : int) -> Mob:
	match prio:
		G.prio.FIRST:
			return get_first_mob()
		G.prio.LAST:
			return get_last_mob()
		G.prio.CLOSE:
			return get_closest_mob()
		_:
			push_error("Invalid target priority!")
			return null

func get_first_mob() -> Mob:
	if mobs_in_range.is_empty():
		return null
	else:
		var first_mob = mobs_in_range[0]
		
		for mob_i in mobs_in_range:
			if mob_i.pathfollow.get_progress() > first_mob.pathfollow.get_progress():
				first_mob = mob_i
		
		return first_mob

func get_last_mob() -> Mob:
	if mobs_in_range.is_empty():
		return null
	else:
		var last_mob = mobs_in_range[0]
		
		for mob_i in mobs_in_range:
			if mob_i.pathfollow.get_progress() < last_mob.pathfollow.get_progress():
				last_mob = mob_i
		
		return last_mob

func get_closest_mob() -> Mob:
	if mobs_in_range.is_empty():
		return null
	else:
		var close_mob = mobs_in_range[0]
		
		for mob_i in mobs_in_range:
			if global_position.distance_to(close_mob.global_position) > global_position.distance_to(mob_i.global_position):
				close_mob = mob_i
		
		return close_mob

func get_target_priority() -> int:
	return target_prio

func set_target_priority(prio : int) -> void:
	target_prio = prio

func update_range() -> void:
	range_collision.shape.radius = attribute[G.att.RANGE]

func update_cooldown() -> void:
	cooldown_seconds = 50 / attribute[G.att.ATTACK_SPEED]

#Mousebox processes even when paused so you cant stack towers
func _on_mousebox_mouse_entered() -> void:
	mouseovered = true

func _on_mousebox_mouse_exited() -> void:
	mouseovered = false

func _on_projectile_damage_dealt(a : int, c : bool, p : Vector2) -> void:
	total_damage_dealt += a
	damage_dealt.emit(a, c, p)

func _draw() -> void:
	if range_indicator_visible:
		draw_circle(Vector2.ZERO, attribute[G.att.RANGE], Color(0,0,0,0.2))

func set_range_indicator_visibility(new_visibility : bool) -> void:
	range_indicator_visible = new_visibility
	queue_redraw()

func _on_data_panel_button_pressed() -> void:
	clicked.emit(self)

func get_sprite_texture() -> Texture2D:
	return sprite.texture
