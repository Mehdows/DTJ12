class_name Door extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var open_door_layer: TileMapLayer = $OpenDoorLayer
@onready var closed_door_layer: TileMapLayer = $ClosedDoorLayer
@onready var area_south: Area2D = $AreaSouth
@onready var area_north: Area2D = $AreaNorth

var is_open: bool
var player_in_south: bool = false  # Track if the player is in the south area


@export_enum("Entrance", "Exit") var door_type: String = "Entrance" 

signal door_pass(door_type: String)

func _ready() -> void:
	# Set up the door based on the door type
	match door_type:
		"Entrance":
			is_open = true
			animation_player.play("open_door")
		"Exit":
			animation_player.play("close_door")
			is_open = false
	
	# Connect the signals for area detection
	area_south.connect("area_entered",  _on_area_south_entered)
	area_south.connect("area_exited", _on_area_south_exited)
	area_north.connect("area_entered",  _on_area_north_entered)
	area_north.connect("area_exited",  _on_area_north_exited)


func _on_area_south_entered(area: Area2D) -> void:
	# When the player enters the south area, mark that they are in the south area
	if area.is_in_group("player"):
		player_in_south = true

func _on_area_south_exited(area: Area2D) -> void:
	# When the player exits the south area, mark that they are no longer in the south area
	if area.is_in_group("player"):
		player_in_south = false

func _on_area_north_entered(area: Area2D) -> void:
	# If the player enters the north area and was already in the south area, emit the signal
	if area.is_in_group("player") and player_in_south:
		if door_type == "Entrance":
			emit_signal("door_pass", "Entrance")  # Player is passing through the entrance
		elif door_type == "Exit":
			emit_signal("door_pass", "Exit")  # Player is passing through the exit
		player_in_south = false

func _on_area_north_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		pass
