class_name HitBox
extends Area2D

@export var damage: int
@export var shape: Shape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape_2d.shape = shape
