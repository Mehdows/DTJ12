extends Area2D

@onready var transition: LevelTransition = $"../Transition"
@onready var room_final_left: RoomManager = $".."

var player_inside = false

func _on_body_entered(body: Node2D) -> void:
	print("Player entered boss area")
	if body.is_in_group("player") and room_final_left.room_loaded:
		transition.begin_transition()



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
