
class_name RewardGiver extends Area2D

@onready var reward_ui: Panel = $CanvasLayer/Control/Panel


var player_inside = false
var reward_data : Resource  # This will store the reward data (like what happens if picked)

# This function will be called when a player enters the Area2D
func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		reward_ui.visible = true
		# reward_ui.get_node("Label").text = reward_data.reward_description

# This function will be called when a player exits the Area2D
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		reward_ui.visible = false

func _ready():
	reward_ui.visible = false
