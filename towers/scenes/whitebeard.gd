extends Tower

@export var bird_resource : Resource
@export var bird : Projectile

func _ready() -> void:
	super()
	reset_bird()
	#update_bird()

#func update_bird() -> void:
	#bird.init(self, attribute[G.att.DAMAGE], attribute[G.att.CRIT_MULT], 0, attribute[G.att.PROJ_SPEED], attribute[G.att.PIERCE], attribute[G.att.RANGE], Vector2(0, -1), Vector2.ZERO, 0)

func reset_bird() -> void:
	if bird != null:
		bird.queue_free()
	
	bird = bird_resource.instantiate()
	bird.damage_dealt.connect(_on_projectile_damage_dealt)
	add_child(bird)
	bird.init(self, attribute[G.att.DAMAGE], attribute[G.att.CRIT_MULT], 0, attribute[G.att.PROJ_SPEED], attribute[G.att.PIERCE], attribute[G.att.RANGE], Vector2(0, -1), Vector2.ZERO, 0)

func upgrade_attribute(att : int, amount : float) -> void:
	super(att, amount)
	reset_bird()
	#update_bird()
