@tool
extends Camera2D

@export var camera_target: NodePath  
@export var camera_radius: float = 250.0 

@onready var camera_center: Marker2D = %CameraCenter

func _ready():
	if not camera_center:
		push_warning("Camera Center Marker2D is not assigned!")

func _process(delta):
	_process_editor()
	if not Engine.is_editor_hint() and camera_target:
		var target_node = get_node_or_null(camera_target)
		if target_node:
			var target_pos = target_node.global_position  # Get target position

			# Clamp the camera within the defined radius
			var direction = target_pos - camera_center.global_position
			if direction.length() > camera_radius:
				target_pos = camera_center.global_position + direction.normalized() * camera_radius

			# Smooth camera movement
			global_position = global_position.lerp(target_pos, delta * 5.0)


func _draw():
	if Engine.is_editor_hint() and camera_center:
		draw_circle(camera_center.global_position - global_position, camera_radius, Color(1, 0, 0, 0.5))

func _process_editor():
	queue_redraw()  # Continuously update gizmo in the editor
