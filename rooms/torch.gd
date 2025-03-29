extends PointLight2D

# Export range values for the min and max intensity of the light
@export_range(0.1, 2.0) var min_energy : float = 0.5
@export_range(0.1, 2.0) var max_energy : float = 1.5

# Export range values for the scale of the light
@export_range(0.5, 2.0) var min_scale : float = 0.8
@export_range(0.5, 2.0) var max_scale : float = 1.2

# Duration for each tweening step (time to reach max and min values)
@export_range(0.1, 2.0) var tween_duration : float = 1.0

var tween : Tween

func _ready():
	# Start the flickering effect
	_animate_torch()

# Function to animate the flickering effect of the torch
func _animate_torch():
	# Create a new tween each time
	tween = create_tween()

	# Randomize the energy range for more dynamic flickering
	var random_min_energy = randf_range(min_energy * 0.8, min_energy * 1.2)  # Slight variation
	var random_max_energy = randf_range(max_energy * 0.8, max_energy * 1.2)  # Slight variation

	# Randomize the scale range for more dynamic flickering
	var random_min_scale = randf_range(min_scale * 0.8, min_scale * 1.2)  # Slight variation
	var random_max_scale = randf_range(max_scale * 0.8, max_scale * 1.2)  # Slight variation
	
	# Randomize tween duration to make the flickering more irregular
	var random_duration = randf_range(tween_duration * 0.5, tween_duration * 1.5)

	# Tween the energy of the light (flickering effect)
	tween.tween_property(self, "energy", random_max_energy, random_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "energy", random_min_energy, random_duration).set_trans(Tween.TRANS_SINE)

	# Tween the scale of the light (simulating the expansion and contraction of the flame)
	tween.tween_property(self, "scale", Vector2(random_max_scale, random_max_scale), random_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(random_min_scale, random_min_scale), random_duration).set_trans(Tween.TRANS_SINE)

	# Wait for the tween to finish before restarting the animation
	_wait_for_tween()

# Helper function to wait for the tween to finish
func _wait_for_tween() -> void:
	# Wait for the finished signal to be emitted
	await tween.finished
	
	# Restart the animation after the tween finishes
	_animate_torch()
