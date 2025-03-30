extends Node2D
class_name HealthComponent

signal death()

var health: int = 100:
	set(amount):
		if amount <= 0:
			death.emit()
		health = amount
		print(health)
	get:
		return health
var max_health: int = 100
var regeneration: float = 1

func _on_timer_timeout():
	health += ceil(regeneration)
	clamp(health, 0, max_health)

func take_damage(damage):
	health -= damage
	
func add_max_health(amount: int):
	var current_health_perchantage = health/max_health
	max_health = max_health + amount
	health = max_health*current_health_perchantage
