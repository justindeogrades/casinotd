extends Node
class_name G

enum rarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY
}

	#"Damage:",
	#"Attack speed:",
	#"Range:",
	#"Crit chance:",
	#"Crit multiplier:",
	#"Projectile speed:",
	#"Projectile count:",
	#"Pierce:"
enum att {
	DAMAGE,
	ATTACK_SPEED,
	RANGE,
	CRIT_CHANCE,
	CRIT_MULT,
	PROJ_SPEED,
	PROJ_COUNT,
	PIERCE
}

enum face {
	JACK,
	QUEEN,
	KING,
	ACE
}

enum prio {
	FIRST,
	LAST,
	CLOSE
}

enum type {
	VOLLEY,
	FAN,
	SURROUND
}

static func face_to_letter(f : int) -> String:
	match f:
		face.JACK:
			return "J"
		face.QUEEN:
			return "Q"
		face.KING:
			return "K"
		face.ACE:
			return "A"
		_:
			push_error("Attempting to convert invalid face to letter!")
			return " "

static func rarity_to_colour(r : int) -> Color:
	
	
	match r:
		rarity.COMMON:
			return Color.LIME_GREEN
		rarity.UNCOMMON:
			return Color.DEEP_SKY_BLUE
		rarity.RARE:
			return Color.ORANGE_RED
		rarity.LEGENDARY:
			return Color.YELLOW
		_:
			push_error("Attempting to convert invalid rarity to colour!")
			return Color.WHITE
