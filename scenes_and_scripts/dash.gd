extends Ability

const HIT_BOX = preload("res://scenes_and_scripts/hit_box.tscn")

@onready var dash_bar: ProgressBar = $"../CanvasLayer/PlayerUIContainer/DashBar"

@export var dash_enable = false
@export var dash_speed = 500
@export var dash_damage = 30
@export var dash_attack_size = 30
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0

var dash_attack
var dash_duration_timer
var cooldown_timer: Timer
var cooldown_elapsed: float = 0.0

func _ready() -> void:
	ability_name_event = "dash"
	cooldown = dash_cooldown
	
	# Initialize the dash attack and cooldown timer
	var parent = get_parent()
	dash_attack = HIT_BOX.instantiate()
	dash_attack.collision_layer = 0
	dash_attack.damage = dash_damage
	dash_attack.get_child(0).shape = CircleShape2D.new()
	dash_attack.get_child(0).shape.radius = dash_attack_size
	add_child(dash_attack)
	
	# Timer for dash duration
	dash_duration_timer = Timer.new()
	add_child(dash_duration_timer)
	dash_duration_timer.wait_time = dash_duration
	dash_duration_timer.one_shot = true
	dash_duration_timer.connect("timeout", Callable(self, "_end_dash"))
	
	# Timer for cooldown
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.one_shot = false  # Set to false to allow for continuous updates
	cooldown_timer.connect("timeout", Callable(self, "_on_dash_ready"))
	
	super()

func ability() -> void:
	var parent = get_parent()
	var direction = parent.velocity.normalized()

	# Use last input direction if standing still
	if direction == Vector2.ZERO:
		direction = parent.last_input_direction

	# If still zero (e.g., no movement input yet), prevent dash
	if direction == Vector2.ZERO:
		return
	
	# Start the dash
	parent.immovable = true
	parent.invincible = true
	parent.velocity = direction * dash_speed
	parent.set_collision_mask_value(8, false)  # Disable gap layer mask during dash
	
	dash_attack.collision_layer = 1
	dash_duration_timer.start()
	dash_bar.value = 0  # Set to 0 when dashing

	if parent.animation_player.is_playing() and parent.animation_player.current_animation == "attack":
		parent.animation_player.stop()
	parent.animation_player.play("dash")

	# Start cooldown after the dash
	cooldown_timer.start()
	cooldown_elapsed = 0.0  # Reset the cooldown progress

func _end_dash():
	var parent = get_parent()
	parent.immovable = false
	parent.invincible = false
	dash_attack.set_process(false)
	dash_attack.collision_layer = 0
	parent.set_collision_mask_value(8, true)
	parent.can_attack = true

	# After the dash ends, begin to fill the dash bar based on the cooldown
	cooldown_timer.start()  # Start the cooldown timer
	dash_bar.value = 0  # Reset to 0 when dash ends

func _on_dash_ready():
	# Once the cooldown is ready, set dash_bar to 100 to indicate readiness
	dash_bar.value = 100

func _process(delta):
	# Update the cooldown progress and dash bar during the cooldown period
	if cooldown_timer:
		cooldown_elapsed += delta
		# Fill the dash bar linearly from 0 to 100 as the cooldown progresses
		dash_bar.value = lerp(0, 100, cooldown_elapsed / dash_cooldown)
