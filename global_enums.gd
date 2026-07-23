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
			return Color.from_rgba8(90, 197, 79)
		rarity.UNCOMMON:
			return Color.from_rgba8(12, 241, 255)
		rarity.RARE:
			return Color.from_rgba8(196, 36, 48)
		rarity.LEGENDARY:
			return Color.from_rgba8(255, 200, 37)
		_:
			push_error("Attempting to convert invalid rarity to colour!")
			return Color.WHITE

static func rarity_to_string(r : int) -> String:
	match r:
		rarity.COMMON:
			return "Common"
		rarity.UNCOMMON:
			return "Uncommon"
		rarity.RARE:
			return "Rare"
		rarity.LEGENDARY:
			return "Legendary"
		_:
			push_error("Attempting to convert invalid rarity to colour!")
			return " "
