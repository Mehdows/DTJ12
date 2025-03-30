# SlashEffect.gd
class_name SlashEffect extends Node2D


@onready var sprite: Sprite2D = $VFXSprite
@onready var attack_animation_player: AnimationPlayer = $AttackAnimationPlayer

func _ready():
	attack_animation_player.play("slash")
	attack_animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name):
	queue_free()
