
class_name RewardGiver extends Node2D

@onready var reward_ui: Panel = $CanvasLayer/Control/Panel
@onready var picture: TextureRect = $CanvasLayer/Control/Panel/VBoxContainer/TextureRect
@onready var title: Label = $CanvasLayer/Control/Panel/VBoxContainer/Label
@onready var description: RichTextLabel = $CanvasLayer/Control/Panel/VBoxContainer/RichTextLabel

@export var resource: Augment

var player_inside = false
var reward_data : Resource  # This will store the reward data (like what happens if picked)
var player: CharacterBody2D
# This function will be called when a player enters the Area2D
func _on_body_entered(body):
	picture.texture = resource.image
	title.text = resource.title
	description.text = resource.description
	if body.is_in_group("player"):
		player_inside = true
		reward_ui.visible = true
		player = body


# This function will be called when a player exits the Area2D
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		reward_ui.visible = false

func _ready():
	reward_ui.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and player_inside:
		resource.apply_augment(player)
		get_parent().augment_picked()
