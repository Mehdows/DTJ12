extends Node2D
class_name MonsterAI

@export var speed: int = 100

@onready var parent = get_parent()

func _physics_process(_delta: float) -> void:
	var monster_position = parent.global_position
	var direction_vec = (get_player_position() - monster_position).normalized()
	parent.velocity = direction_vec * speed
	parent.move_and_slide()
	print(monster_position)
	

func get_player_position() -> Vector2:
	if Global.game_controller.player:
		return Global.game_controller.player.global_position
	return Vector2.ZERO
