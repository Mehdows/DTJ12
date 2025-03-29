extends Resource
class_name WaveResource

@export var enemy_types: Array[PackedScene] # List of enemy scenes to spawn
@export var enemy_count: int = 5  # Total enemies in the wave
@export var spawn_points: Array[int] = [0, 1, 2, 3] # Available spawn points
@export var spawn_pattern: String = "random" # Could be "random", "sequential", "grouped"
@export var delay_between_spawns: float = 1.0 # Time between each enemy spawn
@export var wave_start_delay: float = 3.0 # Delay before the wave starts
@export var enemy_speed_multiplier: float = 1.0 # Modify speed for fast waves
@export var enemy_health_multiplier: float = 1.0 # Modify health for harder waves
