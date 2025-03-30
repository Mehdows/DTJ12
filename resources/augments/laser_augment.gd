extends Augment

const LASERABILITY = preload("res://scenes_and_scripts/laserability.tscn")

func apply_augment(player):
	player.add_child(LASERABILITY.instantiate())
