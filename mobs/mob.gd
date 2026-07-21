class_name Mob
extends Node2D

@export_category("Stats")
@export var max_hp : int
## The path progress made per frame
@export var speed : float
@export var min_bounty : int
@export var max_bounty : int
@export var is_boss : bool
@export_category("Components")
@export var hp_label : Label
@export var sprite : AnimatedSprite2D
@export var anim_player : AnimationPlayer

var player : Node
var pathfollow : PathFollow2D
var bounty : int

var dying : bool = false

signal deleted

@onready var hp = max_hp

func _ready() -> void:
	pathfollow = get_pathfollow()
	bounty = roll_bounty()
	
	sprite.play()
	
	#hp_label.position = Vector2(0, 15)
	update_hp_label()

func take_damage(damage : int) -> void:
	hp -= damage
	
	if hp <= 0:
		death()
	else:
		anim_player.play("hitflash")
	
	update_hp_label()

func death() -> void:
	dying = true
	speed = 0
	
	player.update_money(bounty)
	anim_player.play("death")

func delete_self() -> void:
	#Deleted signal just allows the wave to end
	deleted.emit(self)
	pathfollow.queue_free()

#Make this not fucking stupid later
func get_pathfollow() -> PathFollow2D:
	return get_parent()

func _process(delta: float) -> void:
	pathfollow.set_progress(pathfollow.get_progress() + speed*delta)
	
	if pathfollow.progress_ratio >= 1:
		leak()

#Called when mob reaches the exit, just deletes the pathfollow for now
func leak() -> void:
	player.update_lives(-1)
	delete_self()

func roll_bounty() -> int:
	return randi_range(min_bounty, max_bounty)

func update_hp_label() -> void:
	var hp_to_display = hp
	
	if hp_to_display < 0:
		hp_to_display = 0
	
	hp_label.text = "HP: " + str(hp_to_display) + " / " + str(max_hp)

func is_dying() -> bool:
	return dying

func _on_detection_box_mouse_entered() -> void:
	hp_label.visible = true
func _on_detection_box_mouse_exited() -> void:
	hp_label.visible = false
