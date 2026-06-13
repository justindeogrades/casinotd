extends Projectile

@export var speed_curve : Curve

var seconds_to_target : float
var frames_alive : float = 0

func _ready() -> void:
	super()

func init(t : Tower, d : int, cm : float, cl : int, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	super(t, d, cm, cl, ps, p, r, dir, pos, dist)
	seconds_to_target = dist / ps
	#print_debug("seconds to target: " + str(seconds_to_target))

func _physics_process(delta : float) -> void:
	var seconds_alive = frames_alive / 60
	var x = seconds_alive / (3 * seconds_to_target)
	#print_debug("x = " + str(seconds_alive) + " / " + str(3 * seconds_to_target))
	#print_debug("x: " + str(x))
	var new_speed = speed_curve.sample(x) * speed
	linear_velocity = direction * new_speed
	frames_alive += 1
	
	if x >= 1:
		queue_free()
