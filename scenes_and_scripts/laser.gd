extends HitBox

@onready var line: Line2D = $Line2D

@export var speed: float = 400
@export var lifetime: float = 1.0

var direction: Vector2

func _ready():
	# Auto-remove laser after some time
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()
	
	# DEBUGGING
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(direction * 50)  # Extend line
	
func _process(delta):
	global_position += direction * speed * delta
