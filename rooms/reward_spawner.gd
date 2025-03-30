class_name RewardSpawner extends Node2D

@export  var reward1 : PackedScene
@export var reward2 : PackedScene
@export  var reward3 : PackedScene

func spawn_reward_givers():
	# Spawn the first RewardGiver at position (0, 0)
	var reward_giver1 = reward1.instantiate()
	reward_giver1.resource = preload("res://resources/augments/dash.tres")
	reward_giver1.position = Vector2(0, 0)  
	add_child(reward_giver1)

	# Spawn the second RewardGiver at position (-100, 0)
	var reward_giver2 = reward2.instantiate()
	reward_giver2.resource = preload("res://resources/augments/laser.tres")
	reward_giver2.position = Vector2(-100, 0)  
	add_child(reward_giver2)

	# Spawn the third RewardGiver at position (100, 0)
	var reward_giver3 = reward3.instantiate() 
	reward_giver3.position = Vector2(100, 0)  
	add_child(reward_giver3)
	
func augment_picked():
	$".".queue_free()
