class_name Door extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var open_door_layer: TileMapLayer = $OpenDoorLayer
@onready var closed_door_layer: TileMapLayer = $ClosedDoorLayer
@onready var area_south: Area2D = $AreaSouth
@onready var area_north: Area2D = $AreaNorth
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_open: bool
var player_in_south: bool = false  # Track if the player is in the south area

@export_enum("Entrance", "Exit") var door_type: String = "Entrance" 

signal door_pass(door_type: String)

func _ready() -> void:
	# Set up the door based on the door type
	match door_type:
		"Entrance":
			open_door()
		"Exit":
			close_door()

# Function to open the door
func open_door() -> void:
	animation_player.play("open_door")


# Function to close the door
func close_door() -> void:
	animation_player.play("close_door")


func _on_area_south_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_south = true


func _on_area_south_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_south = false


func _on_area_north_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and player_in_south:
		if door_type == "Entrance":
			emit_signal("door_pass", "Entrance")
		elif door_type == "Exit":
			emit_signal("door_pass", "Exit")
		player_in_south = false


func _on_area_north_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_door":
		is_open = false
		collision_shape.disabled = false
		collision_layer = 5
		collision_mask = 5
	elif anim_name == "open_door":
		is_open = true

		collision_shape.disabled = true
		collision_layer = 0
		collision_mask = 0
