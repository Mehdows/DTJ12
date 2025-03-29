class_name HurtBox
extends Area2D

#const hitEffectScene = preload("res://some_folder/hit_effect.tscn")
@export var shape: Shape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape_2d.shape = shape

func hit_effect():
	#var hitEffect : Node2D = hitEffectScene.instantiate() as Node2D
	#var main = get_tree().current_scene
	#main.add_child(hitEffect)
	#hitEffect.global_position = global_position
	pass
