class_name LevelTransition extends Node

@onready var transition_camera: Camera2D = %TransitionCamera
@onready var transition_animation_player: AnimationPlayer = $TransitionAnimationPlayer

func _ready():
	transition_camera.enabled = false  
	var player_camera = get_player_camera()
	if player_camera:
		player_camera.make_current()  

func begin_level():
	transition_camera.enabled = true  
	transition_camera.make_current()
	transition_animation_player.play("begin_level")

func begin_transition():
	transition_camera.enabled = true  
	transition_camera.make_current()
	transition_animation_player.play("enter_level")

func disable_player_control():
	Global.game_controller.player.lock_movement()

func enable_player_control():
	transition_camera.enabled = false  
	Global.game_controller.player.unlock_movement()
	Global.game_controller.player.get_node("Camera2D").make_current()

func complete_transition():
	Global.game_controller.load_next_room()

func get_player_camera() -> Camera2D:
	if Global.game_controller and Global.game_controller.player:
		return Global.game_controller.player.get_node_or_null("Camera2D")
	return null
