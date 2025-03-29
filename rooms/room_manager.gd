class_name RoomManager extends Node2D

signal room_cleared()  # Signal emitted when the room is cleared
signal room_started()  # Signal emitted when the room starts

@onready var doors_manager: DoorManager = $DoorsManager
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var transition: LevelTransition = $Transition

var is_room_started: bool = false
var is_room_cleared: bool = false

func _ready() -> void:
	doors_manager.connect("door_passed", _on_door_pass)
	enemy_spawner.connect("waves_complete", _on_waves_complete)

func _on_door_pass(door_type: String) -> void:
	if door_type == "Entrance" and not is_room_started:
		start_room()

	if door_type == "Exit" and is_room_cleared:
		print("Player exited the room, transitioning to the next room")
		transition.begin_transition()
		#Global.game_controller.load_next_room()

# Starts the room, called when the player enters
func start_room():
	if not is_room_started:
		is_room_started = true
		is_room_cleared = false

		# Emit the room_started signal to inform the GameController and other systems
		emit_signal("room_started")
		
		enemy_spawner.start_waves()

# When the room is cleared, this function will be called
func clear_room():
	if not is_room_cleared:
		is_room_cleared = true
		
		# Emit the room_cleared signal to update the door states
		emit_signal("room_cleared")
		print("Room cleared, exit is now open!")

func _on_waves_complete(current_wave: int, total_waves: int) -> void:
	print("Wave completed:", current_wave, "of", total_waves)
	if current_wave == total_waves:
		clear_room()
