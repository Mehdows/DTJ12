extends Camera2D

var shake_intensity = 0.0

var is_shaking = false

func _process(delta):
	if shake_intensity > 0:
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		shake_intensity = max(shake_intensity, 0)

func start_shake(intensity: float):
	is_shaking = true
	shake_intensity = intensity

func stop_shake():
	is_shaking = false
	shake_intensity = 0
	offset = Vector2.ZERO  # Instantly reset shake
