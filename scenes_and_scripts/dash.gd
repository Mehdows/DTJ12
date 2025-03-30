extends Ability
const HIT_BOX = preload("res://scenes_and_scripts/hit_box.tscn")

@export var dash_enable = false
@export var dash_speed = 500
@export var dash_damage = 30
@export var dash_attack_size = 30
@export var dash_duration = 0.2
@export var dash_cooldown = 1.0
var dash_attack
var dash_duration_timer

func _ready() -> void:
	
	ability_name_event = "dash"
	cooldown = dash_cooldown
	
	var parent = get_parent()
	dash_attack = HIT_BOX.instantiate()
	dash_attack.collision_layer = 0
	dash_attack.damage = dash_damage
	dash_attack.get_child(0).shape = CircleShape2D.new()
	dash_attack.get_child(0).shape.radius = dash_attack_size
	add_child(dash_attack)
	
	dash_duration_timer = Timer.new()
	add_child(dash_duration_timer)
	dash_duration_timer.wait_time = dash_duration
	dash_duration_timer.one_shot = true
	dash_duration_timer.connect("timeout", Callable(self, "_end_dash"))
	super()

func ability() -> void:
	var parent = get_parent()
	var direction = (parent.velocity).normalized()
	if direction == Vector2.ZERO:
		return
		
	parent.immovable = true
	parent.invincible = true
	parent.velocity = direction * dash_speed

	dash_attack.collision_layer = 1
	dash_duration_timer.start()

func _end_dash():
	var parent = get_parent()
	parent.immovable = false
	parent.invincible = false
	dash_attack.set_process(false)
	dash_attack.collision_layer = 0
	
