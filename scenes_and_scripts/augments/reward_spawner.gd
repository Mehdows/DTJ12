class_name RewardSpawner extends Node2D

@export  var reward1 : PackedScene
@export var reward2 : PackedScene
@export  var reward3 : PackedScene
const augments = [
	preload("res://resources/augments/laser.tres"),
	preload("res://resources/augments/damage.tres"),
	preload("res://resources/augments/health.tres"),
	preload("res://resources/augments/speed.tres")
	]
	
func spawn_reward_givers():
	var nums = generate_unique_random_numbers(0, len(augments)-1)
	# Spawn the first RewardGiver at position (0, 0)
	var reward_giver1 = reward1.instantiate()
	reward_giver1.resource = augments[nums[0]]
	reward_giver1.position = Vector2(0, 0)  
	add_child(reward_giver1)

	# Spawn the second RewardGiver at position (-100, 0)
	var reward_giver2 = reward2.instantiate()
	reward_giver2.resource = augments[nums[1]]
	reward_giver2.position = Vector2(-100, 0)  
	add_child(reward_giver2)

	# Spawn the third RewardGiver at position (100, 0)
	var reward_giver3 = reward3.instantiate() 
	reward_giver3.resource = augments[nums[2]]
	reward_giver3.position = Vector2(100, 0)  
	add_child(reward_giver3)
	
func augment_picked():
	$".".queue_free()

func generate_unique_random_numbers(min_val: int, max_val: int) -> Array:
	var numbers := []
	while numbers.size() < 3:
		var rand_num = randi() % (max_val - min_val + 1) + min_val
		if rand_num not in numbers:
			numbers.append(rand_num)
	return numbers
