extends Tower

func _process(delta: float) -> void:
	super(delta)
	
	if not anim_player.is_playing():
		anim_player.play("hover")
