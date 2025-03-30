extends Node2D
class_name MonsterAI

@export var speed: int = 100
@export var chase_cooldown: float = 0.5 # Time before AI resumes chasing

@onready var parent = get_parent()
@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	# Create and configure cooldown timer
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = chase_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(cooldown_timer)

func _physics_process(delta: float) -> void:
	# Stop chasing while cooldown is active
	if cooldown_timer.time_left > 0:
		return 
	
	var monster_position = parent.global_position
	var direction_vec = (get_player_position() - monster_position).normalized()
	parent.velocity = direction_vec * speed
	parent.move_and_slide()

func get_player_position() -> Vector2:
	if Global.game_controller.player:
		return Global.game_controller.player.global_position
	return Vector2.ZERO

func start_chase_cooldown():
	cooldown_timer.start()

func _on_cooldown_timeout():
	pass # No action needed, AI will resume naturally
