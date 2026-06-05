extends Projectile

func init(t : Tower, d : int, cm : float, cl : int, ps : float, p : int, r : float, dir : Vector2, pos : Vector2, dist : float) -> void:
	init_angle_offset = randf_range(-PI/6, PI/6)
	super(t, d, cm, cl, ps, p, r, dir, pos, dist)
