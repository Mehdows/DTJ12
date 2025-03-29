class_name GameController extends Node

@export var room_scenes: Array[PackedScene] = []

@onready var player_scene = preload("res://scenes_and_scripts/player.tscn")
@onready var world: Node2D = $World

var player  
var current_room_index = 0
var current_room_instance

var current_world: Node2D

func _ready() -> void:
	Global.game_controller = self
	
	# Debugging print for room scenes array
	print("Room scenes array:", room_scenes)

	# Ensure we load the first room if available
	if room_scenes.size() > 0:
		load_first_room()
	else:
		print("Error: No rooms available in the room_scenes array!")

func load_first_room():
	# Ensure we load the first room from the array and set up player spawn
	if room_scenes.size() > 0:
		print("Loading first room...")

		# Instantiate the first room and place it as a child of the world node
		current_room_instance = room_scenes[0].instantiate()
		world.add_child(current_room_instance)
		spawn_player()

		# Move to the next room index for future loading
		current_room_index = 1
	else:
		print("Error: No rooms in the array!")

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if delete and current_world:
		current_world.queue_free()
	elif keep_running:
		current_world.visible = false
	
	# Instantiate and add the new scene to the world
	var new_scene_instance = load(new_scene).instantiate()
	world.add_child(new_scene_instance)
	current_world = new_scene_instance

func load_next_room():
	if current_room_index < room_scenes.size():
		# Debug print to see which room we're trying to load
		print("Loading room index: ", current_room_index)

		# Instantiate and add the new room
		current_room_instance = room_scenes[current_room_index].instantiate()
		world.add_child(current_room_instance)  # Add the room as a child of the world node
		
		# Then spawn the player inside it
		spawn_player()

		# Increment the room index
		current_room_index += 1
	else:
		print("All rooms completed!")

func spawn_player():
	# Debug print to confirm the player spawn logic
	print("Spawning player...")

	# Check if the room has an entrance door
	var entrance = current_room_instance.get_node("Doors/EntranceDoor")
	if entrance:
		# Instantiate the player and add it to the room
		player = player_scene.instantiate()
		current_room_instance.add_child(player)  # Add player to the current room
		player.global_position = entrance.global_position + Vector2(0, 50)  # Adjust spawn position
		print("Player spawned at: ", player.global_position)
	else:
		print("No EntranceDoor found in this room!")
