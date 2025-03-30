extends Augment

const LASERABILITY = preload("res://scenes_and_scripts/laserability.tscn")

func apply_augment(player):
	player.add_child(LASERABILITY.instantiate())

func _init() -> void:
	title = "Laser"
	description = "Shoot a laser with the Q key, deals 2x damage"
	image = preload("res://assets/sword.png")
