extends Label

@export var base_increment_per_second : int = 1
@export var difference_threshold : int = 200
@export var threshold_exceeded_multiplier : int = 10

var effective_val : int = 0
var displayed_val : int = 0

func _process(delta: float) -> void:
	var ips = base_increment_per_second
	if abs(effective_val - displayed_val) >= difference_threshold:
		var m = floor(abs(effective_val - displayed_val) / difference_threshold)
		ips *= m * threshold_exceeded_multiplier
	
	if effective_val > displayed_val:
		displayed_val += ips
		if displayed_val > effective_val:
			displayed_val = effective_val
	elif effective_val < displayed_val:
		displayed_val -= ips
		if displayed_val < effective_val:
			displayed_val = effective_val
	text = str(displayed_val)

func set_effective_value(v : int) -> void:
	effective_val = v

func fix_displayed_value() -> void:
	displayed_val = effective_val
