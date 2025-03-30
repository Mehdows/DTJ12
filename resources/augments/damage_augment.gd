extends Augment

func _ready() -> void:
	title = "Damage"
	description = "Adds 20 damage points. Your base damage is 40"
	image = preload("res://assets/sword.png")

func apply_augment(player):
	player.damage += 20
	
