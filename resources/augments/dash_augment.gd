extends Augment

const DASH = preload("res://scenes_and_scripts/dash.tscn")

func apply_augment(player):
	player.add_child(DASH.instantiate())
	
