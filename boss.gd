class_name Boss
extends CharacterBody2D

enum State { IDLE, TRACK, ATTACK, RETREAT }

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox_col: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var hitbox_col: CollisionShape2D = $HitBox/CollisionShape2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit_box: HitBox = $HitBox

@export var resource: EnemyResource
@export var speed: float = 150.0
@export var attack_distance: float = -50.0  # Distance from player to stop and attack
@export var retreat_point: Array[Vector2] = []

var current_state = State.IDLE
var target_position: Vector2
var attack_performed = false
var player_position_cache: Vector2 = Vector2.ZERO 

# Define attack options
var attack_animations = ["shoot2"]

# Timers
@onready var retreat_timer: Timer = $RetreatTimer
@onready var attack_timer: Timer = $AttackTimer

var last_retreat_point: Vector2

signal dead(enemy: Node)

func start_behavior():
	for marker in retreat_point:
		print(marker)
	change_state(State.TRACK)

func _ready() -> void:
	hit_box.damage = resource.attack
	hurtbox_col.shape = resource.shape  # Assign the shape for the hurtbox
	hitbox_col.shape = resource.shape   # Assign the shape for the hitbox
	health_component.max_health = resource.health
	health_component.health = resource.health

func _physics_process(delta):
	match current_state:
		State.TRACK:
			track_player(delta)
		State.ATTACK:
			perform_attack()
		State.RETREAT:
			retreat(delta)

func track_player(delta):
	# Only update the player_position_cache when the state is ATTACK or TRACK
	if current_state == State.ATTACK or current_state == State.TRACK: 
		player_position_cache = get_player_position()
	
	if player_position_cache != Vector2.ZERO:
		# Smoothly lerp the Y position of the boss to the player's Y position
		global_position.y = lerp(global_position.y, player_position_cache.y, 0.1)

		# Smoothly lerp the X position to the target
		global_position.x = lerp(global_position.x, player_position_cache.x + attack_distance, 0.1)

		perform_attack()

func perform_attack():
	if !attack_performed:
		attack_performed = true
		var chosen_attack = attack_animations.pick_random()
		debug_print("Boss is ATTACKING with " + chosen_attack)
		animation_player.play(chosen_attack)

func retreat(delta):
	if not target_position:
		target_position = pick_retreat_position()
	global_position =  target_position
	
	animation_player.play("retreat")

func pick_retreat_position() -> Vector2:
	if retreat_point.size() > 0:
		var new_retreat_point = retreat_point.pick_random()
		
		# Keep picking until the new position is different from the last one
		while new_retreat_point == last_retreat_point:
			new_retreat_point = retreat_point.pick_random()
		
		last_retreat_point = new_retreat_point
		print(new_retreat_point)
		return new_retreat_point
	
	return self.global_position

func get_player_position() -> Vector2:
	if Global.game_controller.player:
		return Global.game_controller.player.global_position
	return self.global_position

func change_state(new_state: State):
	if new_state != current_state:
		current_state = new_state
		match new_state:
			State.TRACK:
				attack_performed = false
				debug_print("Boss is TRACKING the player")
			State.ATTACK:
				debug_print("Boss is PREPARING an attack")
				# Cache the player's position when switching to attack state
				player_position_cache = get_player_position()
			State.RETREAT:
				debug_print("Boss is RETREATING")
				target_position = pick_retreat_position()

func debug_print(message: String):
	print(message)

# Timer signal handlers
func _on_attack_timer_timeout():
	# After attack timer expires, change to retreat state
	change_state(State.RETREAT)

func _on_retreat_timer_timeout():
	# After retreat timer expires, resume tracking
	attack_performed = false  # Reset attack status
	change_state(State.TRACK)

# Handle when the hurtbox is hit (taking damage from player's attack)
func _on_hurt_box_area_entered(area: Area2D) -> void:
	print("Boss damaged")
	print(health_component.health)
	health_component.take_damage(area.damage)
	animation_player.play("hit")
	
	# Knockback effect
	var player_pos = get_player_position()
	var boss_pos = global_position
	var knockback_direction = (boss_pos - player_pos).normalized()  # Get direction away from player
	var knockback_strength = 200.0  # Adjust this value for more or less knockback

	velocity += knockback_direction * knockback_strength

# Handling Boss death when health reaches zero
func _on_health_component_death() -> void:
	hit_box.damage = 0
	if animation_player.is_playing() and animation_player.current_animation == "hit":
		await animation_player.animation_finished
	await get_tree().create_timer(0.1).timeout
	animation_player.play("death")
	emit_signal("dead", self)
	get_tree().change_scene_to_file("res://scenes_and_scripts/victory_screen.tscn")
	$".".queue_free()
