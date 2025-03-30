extends Ability

const LASER = preload("res://scenes_and_scripts/laser.tscn")

func _ready() -> void:
	ability_name_event = "ability_1"
	cooldown = 1
	super()
	
func ability() -> void:
	var laser = LASER.instantiate()
	laser.damage = get_parent().damage*2
	laser.global_position = global_position  # Start at player
	laser.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_sibling(laser)  # Add to the same level as the player (not as a child, so it moves freely)
	
	
