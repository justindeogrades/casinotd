class_name Tower
extends Node2D

@export_category("Attributes")
#Set to size 8 in inspector
#"Default" stats are commented below
@export var attribute : Array[float]
#@export var attribute : Array[float] = [
	#30, #Damage
	#100, #Attack speed
	#100, #Range
	#10, #Crit chance (percent)
	#3, #Crit damage multiplier
	#1000, #Projectile speed
	#1, #Projectile count
	#0 #Pierce
#]
#Getter is get_tower_name cause get_name is built in fucking weirdos
@export var tower_name : String = "Tower"
@export var tower_description : String = "A tower."
@export_enum("Volley", "Fan", "Surround") var shot_type : int = G.type.FAN
#Radians per second
@export var projectile_rotation_speed : float = 0
@export var angle_between_projectiles : float = PI / 12
@export_enum("Common", "Uncommon", "Rare", "Legendary") var rarity : int = G.rarity.COMMON
@export_category("Children")
@export var sprite : Sprite2D
@export var portrait : Texture2D
@export var projectile_preload : Resource
@export var projectile_texture : Texture2D
@export var range_area : Area2D
@export var range_collision : CollisionShape2D
@export var cooldown_timer : Timer
@export var volley_cooldown_timer : Timer
@export var projectile : RigidBody2D
@export var projectile_parent : Node
@export var mousebox : Area2D
@export var data_panel_button : Button
@export var anim_player : AnimationPlayer

signal clicked(tower : Tower)
signal damage_dealt(amount : int, crit : int, pos : Vector2)

#@onready var cooldown_seconds = 50 / attack_speed
@onready var cooldown_seconds = 50 / attribute[G.att.ATTACK_SPEED]

var level : int = 1
var mobs_in_range : Array[Mob]
var target_prio : int = G.prio.FIRST
var kills : int = 0
var total_damage_dealt : float = 0
var upgrade_cost : int = 10

#signal mouse_hovering
var mouseovered : bool = false

var volley_dir : Vector2
var volley_target_pos : Vector2
var volley_shots_remaining : int
#Hardcoding 0.1 second interval for now, should scale with attack speed later
var volley_cooldown_seconds : float = 0.1

var range_indicator_visible : bool = false

func _ready() -> void:
	#Make a unique shape so updating it doesn't update all shapes
	#range_collision.shape = range_collision.shape.duplicate(true)
	update_range()
	
	if shot_type == G.type.VOLLEY:
		volley_cooldown_timer.timeout.connect(_on_volley_cooldown_timer_timeout)
	
	#So tower ghosts dont overlap
	set_z_index(1)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouseovered:
		clicked.emit(self)

func _process(delta: float) -> void:
	#Targeting and shooting
	#Only executes code on the same frame as taking a shot
	if not mobs_in_range.is_empty() and cooldown_timer.is_stopped():
		var target = get_target(target_prio)
		if target != null:
			#print_debug("target dying = " + str(target.is_dying()))
			var aim_direction = (target.global_position - position).normalized()
		
			shoot(shot_type, aim_direction, target)
			
			#Angle towards the target
			#Currently snaps to targets position, maybe tween it later
			#Don't know why rotating by pi/2 is necessary but don't change it
			rotate_sprite_to_target(target.global_position)
		
		
		
			anim_player.stop()
			anim_player.play("shoot")
			
			cooldown_timer.start(cooldown_seconds)
		else:
			print_debug("null target!")
	else:
		pass

func rotate_sprite_to_target(target : Vector2) -> void:
	sprite.look_at(target)
	sprite.rotate(PI / 2)

func shoot(type : int, dir : Vector2, target : Mob) -> void:
	match type:
		G.type.VOLLEY:
			if attribute[G.att.PROJ_COUNT] > 1:
				volley_dir = dir
				volley_target_pos = target.global_position
				volley_shots_remaining = attribute[G.att.PROJ_COUNT] - 1
				volley_cooldown_seconds = cooldown_seconds / (2 * attribute[G.att.PROJ_COUNT])
				volley_cooldown_timer.start(volley_cooldown_seconds)
			spawn_projectile(dir, target.global_position)
		G.type.FAN:
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
				#Rotation matrix fuckshit
				var dirprime_x = dir.x * cos(theta) - dir.y * sin(theta)
				var dirprime_y = dir.x * sin(theta) + dir.y * cos(theta)
				var dirprime = Vector2(dirprime_x, dirprime_y).normalized()
					
				spawn_projectile(dirprime, target.global_position)
		G.type.SURROUND:
			#Iterate once per projectile count, offsetting the angle a little every shot
			for i in attribute[G.att.PROJ_COUNT]:
				var theta = (2 * PI * i) / attribute[G.att.PROJ_COUNT]

				#Rotation matrix fuckshit
				var aimprime_x = dir.x * cos(theta) - dir.y * sin(theta)
				var aimprime_y = dir.x * sin(theta) + dir.y * cos(theta)
				var aimprime = Vector2(aimprime_x, aimprime_y).normalized()
					
				#spawn_projectile(aimprime, target.global_position)
				spawn_projectile(aimprime, aimprime)

func spawn_projectile(aim_direction : Vector2, target_pos : Vector2) -> void:
	var crit_level = roll_crit()
	
	var projectile_instance = projectile_preload.instantiate()
	
	#Replacing all ts with an init function
	#projectile_instance.damage = attribute[G.att.DAMAGE]
	#projectile_instance.crit_level = crit_level
	#projectile_instance.damage *= attribute[G.att.CRIT_MULT] ** crit_level
	#projectile_instance.speed = attribute[G.att.PROJ_SPEED]
	#projectile_instance.remaining_pierces = attribute[G.att.PIERCE]
	#projectile_instance.direction = aim_direction
	#projectile_instance.position = position
	
	projectile_instance.init(self, attribute[G.att.DAMAGE], attribute[G.att.CRIT_MULT], crit_level, attribute[G.att.PROJ_SPEED], attribute[G.att.PIERCE], attribute[G.att.RANGE], aim_direction, position, position.distance_to(target_pos))
	#projectile_instance.look_at(target_pos)
	#projectile_instance.rotate(PI / 2)
	projectile_instance.damage_dealt.connect(_on_projectile_damage_dealt)
	
	projectile_parent.add_child(projectile_instance)

#Roll crit function with crit as a binary
#func roll_crit() -> bool:
	#var challenge_num = randf_range(0, 100)
	#
	#if attribute[G.att.CRIT_CHANCE] >= challenge_num:
		#return true
	#return false

#Roll crit with crit as a level
func roll_crit() -> int:
	var crit_level = 0
	var challenge_failed = false
	var i = 1
	
	while not challenge_failed:
		var challenge_num = randf_range(0, 100)
		if attribute[G.att.CRIT_CHANCE] / i >= challenge_num:
			crit_level += 1
			i += 1
		else:
			challenge_failed = true
	
	return crit_level

func upgrade_attribute(att : int, amount : float) -> void:
	attribute[att] += amount
	update_cooldown()
	update_range()

func _on_range_area_entered(area: Area2D) -> void:
	mobs_in_range.append(area.get_parent())

func _on_range_area_exited(area: Area2D) -> void:
	mobs_in_range.erase(area.get_parent())

func _on_volley_cooldown_timer_timeout() -> void:
	if volley_shots_remaining >= 1:
		spawn_projectile(volley_dir, volley_target_pos)
		volley_shots_remaining -= 1
		volley_cooldown_timer.start(volley_cooldown_seconds)

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
		var first_mob = get_mob_that_isnt_dying()
		
		if first_mob == null:
			return null
		#var i = 0
		
		#Make sure dying mob isnt the only possible target
		#while first_mob.is_dying():
			#first_mob = mobs_in_range[i]
			#i += 1
			#
			#if i >= mobs_in_range.size():
				#return null
		#
		for mob_i in mobs_in_range:
			if mob_i.pathfollow.get_progress() > first_mob.pathfollow.get_progress() and not mob_i.is_dying():
				first_mob = mob_i
	
		return first_mob

func get_last_mob() -> Mob:
	if mobs_in_range.is_empty():
		return null
	else:
		var last_mob = get_mob_that_isnt_dying()
		
		if last_mob == null:
			return null
		
		for mob_i in mobs_in_range:
			if mob_i.pathfollow.get_progress() < last_mob.pathfollow.get_progress() and not mob_i.is_dying():
				last_mob = mob_i
		
		return last_mob

func get_closest_mob() -> Mob:
	if mobs_in_range.is_empty():
		return null
	else:
		var close_mob = get_mob_that_isnt_dying()
		
		if close_mob == null:
			return null
		
		for mob_i in mobs_in_range:
			if global_position.distance_to(close_mob.global_position) > global_position.distance_to(mob_i.global_position) and not mob_i.is_dying():
				close_mob = mob_i
		
		return close_mob

func get_mob_that_isnt_dying() -> Mob:
	var i = 0
	var mob_to_return = mobs_in_range[0]
	
	while mob_to_return.is_dying():
		mob_to_return = mobs_in_range[i]
		i += 1
		
		if i >= mobs_in_range.size():
			return null
	return mob_to_return

func get_target_priority() -> int:
	return target_prio

func get_tower_name() -> String:
	return tower_name

func get_tower_description() -> String:
	return tower_description

func get_rarity() -> int:
	return rarity

func get_portrait_texture() -> Resource:
	return portrait

func get_sprite_texture() -> Texture2D:
	return sprite.texture

func get_projectile_texture() -> Texture2D:
	return projectile_texture

func get_projectile_rotation_speed() -> float:
	return projectile_rotation_speed

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

func _on_projectile_damage_dealt(a : int, c : int, p : Vector2) -> void:
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
