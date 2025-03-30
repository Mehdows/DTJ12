extends Node2D
class_name EnemySpawner

@export var waves: Array[WaveResource] 

@onready var spawn_points: Array[Marker2D] = [
	$SpawnPointN, 
	$SpawnPointE, 
	$SpawnPointW, 
	$SpawnPointS
]

signal waves_complete(current_wave: int, total_waves: int)
signal all_enemies_dead(current_wave: int, total_waves: int)  # Emit wave info with the signal

var current_wave_index: int = 0
var spawning: bool = false
var active_enemies: Array = []  # List to track active enemies

func start_waves():
	if not spawning and waves.size() > 0:
		spawning = true
		await get_tree().create_timer(waves[0].wave_start_delay).timeout
		spawn_wave()

func spawn_wave():
	if current_wave_index >= waves.size():
		spawning = false
		waves_complete.emit(current_wave_index, waves.size())
		return

	var wave: WaveResource = waves[current_wave_index]
	var spawn_indices = wave.spawn_points.duplicate() # Get valid spawn points

	# Spawn enemies for this wave
	for i in range(wave.enemy_count):
		if spawn_indices.is_empty():
			continue

		var spawn_index = select_spawn_point(wave, i)
		if spawn_index >= 0 and spawn_index < spawn_points.size():
			spawn_enemy(spawn_points[spawn_index], wave)

		await get_tree().create_timer(wave.delay_between_spawns).timeout
	
	# Check if all enemies are dead after the wave spawn
	current_wave_index += 1
	waves_complete.emit(current_wave_index, waves.size())

	# Wait for the current wave to be completed before spawning the next one
	await get_tree().create_timer(wave.wave_start_delay).timeout
	spawn_wave()

func spawn_enemy(spawn_point: Marker2D, wave: WaveResource):
	if wave.enemy_types.is_empty():
		return

	var enemy_scene: PackedScene = wave.enemy_types[randi() % wave.enemy_types.size()]
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	
	# Modify enemy stats based on the wave type
	if enemy.has_method("set_speed_multiplier"):
		enemy.set_speed_multiplier(wave.enemy_speed_multiplier)
	if enemy.has_method("set_health_multiplier"):
		enemy.set_health_multiplier(wave.enemy_health_multiplier)

	# Connect the enemy's death signal to the `enemy_dead` method
	enemy.connect("dead", _on_enemy_dead)
	
	get_parent().add_child(enemy)

	# Track active enemies
	active_enemies.append(enemy)

func select_spawn_point(wave: WaveResource, i: int) -> int:
	match wave.spawn_pattern:
		"random":
			return wave.spawn_points[randi() % wave.spawn_points.size()]
		"sequential":
			return wave.spawn_points[i % wave.spawn_points.size()]
		"grouped":
			return wave.spawn_points[floor(i / max(1, wave.enemy_count / wave.spawn_points.size())) % wave.spawn_points.size()]
	return wave.spawn_points[0]  # Default case

# New method to handle enemy death
func _on_enemy_dead(enemy: Node):
	active_enemies.erase(enemy)

	# Check if all enemies are dead
	if active_enemies.is_empty():
		# Emit the signal to notify that all enemies in the wave are dead, with current and total wave info
		all_enemies_dead.emit(current_wave_index, waves.size())
