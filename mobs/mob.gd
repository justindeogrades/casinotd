class_name Mob
extends Node2D

@export var hp : float
## The path progress made per frame
@export var speed : float
@export var min_bounty : int
@export var max_bounty : int
@export var is_boss : bool
@export var anim_player : AnimationPlayer

var player : Node
var pathfollow : PathFollow2D
var bounty : int

func _ready() -> void:
	pathfollow = get_pathfollow()
	bounty = roll_bounty()

func take_damage(damage : float) -> void:
	hp -= damage
	
	if hp <= 0:
		death()
	
	anim_player.play("hitflash")

func death() -> void:
	player.update_money(bounty)
	queue_free()

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
	pathfollow.queue_free()

func roll_bounty() -> int:
	return randi_range(min_bounty, max_bounty)
