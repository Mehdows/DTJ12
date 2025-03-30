extends Augment

func _ready() -> void:
	title = "Speed"
	description = "Adds 50 Speed units. What units? Deez units"
	image = preload("res://assets/dash.png")

func apply_augment(player):
	player.speed += 50
