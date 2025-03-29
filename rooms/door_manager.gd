class_name DoorManager extends Node2D

@onready var exit_door: Door = $ExitDoor
@onready var entrance_door: Door = $EntranceDoor

var room_manager: RoomManager

var is_locked: bool = true  # Start with the door locked
var room_cleared: bool = false

signal door_passed(door_type: String) 


func _ready() -> void:	
	# Get the parent (RoomManager)
	room_manager = get_parent()
	
	# Connect signals to the room manager to detect room start and clearing
	room_manager.connect("room_cleared", _on_room_cleared)
	room_manager.connect("room_started", _on_room_started)
	entrance_door.connect("door_pass", _on_door_pass)
	exit_door.connect("door_pass", _on_door_pass)

func _on_room_started():
	print("Room started, closing doors")
	# When the room starts, entrance door closes, exit door is already closed
	is_locked = true
	room_cleared = false
	update_door_state()

func _on_room_cleared():
	print("Room cleared, opening exit")
	# When the room is cleared, entrance door stays locked, exit door opens
	is_locked = false
	room_cleared = true
	update_door_state()


func update_door_state():
	if room_cleared:
		pass
	else:
		# Room started: Entrance closes, Exit remains closed
		if entrance_door.is_open:
			print("Entrance door being closed")
			entrance_door.is_open = false
			entrance_door.animation_player.play("close_door")
		
		if exit_door.is_open:
			exit_door.is_open = false
			exit_door.animation_player.play("close_door")
			

	
		
func _on_door_pass(door_type: String) -> void:
	print("Door passed:", door_type)	
	if door_type == "Entrance":
		print("Player entered through the entrance")
		emit_signal("door_passed", "Entrance")  # Notify the RoomManager
	
	elif door_type == "Exit":
		print("Player exited through the exit")
		emit_signal("door_passed", "Exit")  # Notify the RoomManager
