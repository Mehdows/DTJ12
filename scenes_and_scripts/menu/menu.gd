extends Control


func _ready() -> void:
	MusicManager.play_music(preload("res://assets/music/menu-music-251877.ogg"), true, -10.0)
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://root.tscn")


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes_and_scripts/menu/options.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes_and_scripts/menu/credits.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
