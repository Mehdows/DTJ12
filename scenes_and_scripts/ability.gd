class_name Ability extends Node2D
var timer: Timer

var on_cooldown = false
@export var cooldown = 5.0
@export var ability_name_event: String

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_reset_cooldown"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(ability_name_event):
		if on_cooldown:
			return
		ability()
		set_on_cooldown()

func ability() -> void:
	pass
	
func set_on_cooldown():
	on_cooldown = true
	timer.start()

func _reset_cooldown():
	on_cooldown = false
