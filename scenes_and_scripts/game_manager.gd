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
	player = $World/Player#player_scene.instantiate()
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

		# Connect to the room_started signal of the room manager
		var room_manager = current_room_instance
		room_manager.connect("room_started",  _on_room_started)
		room_manager.connect("room_cleared", _on_room_cleared)
	else:
		print("Error: No rooms in the array!")

# This function will be called when the room is started
func _on_room_started():
	print("Room has started!")
	# You can trigger additional behavior like unlocking certain doors, enemies, etc.

func _on_room_cleared():
	print("Room has been cleared, loading next room!")
	#load_next_room()

# Function to load the next room
func load_next_room():
	if current_room_index < room_scenes.size():
		# Debug print to see which room we're trying to load
		print("Loading room index: ", current_room_index)

		# Remove the old room if it exists
		if current_room_instance:
			print("Removing old room...")
			current_room_instance.queue_free()  # This will free the old room

		# Instantiate and add the new room
		current_room_instance = room_scenes[current_room_index].instantiate()
		world.add_child(current_room_instance)  # Add the room as a child of the world node
		
		# Then spawn the player inside it
		spawn_player()

		# Increment the room index
		current_room_index += 1

		var room_manager = current_room_instance
		room_manager.connect("room_started", _on_room_started)
		room_manager.connect("room_cleared", _on_room_cleared)
	else:
		print("All rooms completed!")

# Function to spawn the player in the room
func spawn_player():
	# Debug print to confirm the player spawn logic
	print("Spawning player...")

	# Find the PlayerSpawnPoint in the room
	var spawn_point = current_room_instance.get_node("PlayerSpawnPoint")
	if spawn_point:
		# Instantiate the player and add it to the room
		
		#add_child(player)  # Add player to the current room

		# Set the player's position to the spawn point's position
		player.global_position = spawn_point.global_position
		print("Player spawned at: ", player.global_position)
	else:
		print("No PlayerSpawnPoint found in this room!")
