extends Augment

func _ready() -> void:
	title = "Health"
	description = "Adds 50 health points. Your max health without upgrades is 100 health points"
	image = preload("res://assets/health.png")

func apply_augment(player):
	player.health_component.add_max_health(50)
