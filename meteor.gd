class_name Meteor
extends Node2D

signal impact(position: Vector2)

@export var fall_speed: float = 400.0
@export var impact_delay: float = 1.5  # Time before the meteor hits

@onready var timer: Timer = $Timer


var target_position: Vector2

func start_fall(target: Vector2):
	target_position = target
	timer.start(impact_delay)  
	emit_signal("impact", target) 

func _on_Timer_timeout():
	global_position = target_position
	explode()

func explode():
	print("Meteor IMPACT at ", global_position)
	queue_free()  
