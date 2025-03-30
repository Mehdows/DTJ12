extends CanvasLayer

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var label: Label = $DeathText
@onready var button: Button = $MenuButton

func _ready():
	fade_overlay.modulate.a = 0
	label.hide()
	button.hide()

func start_fade():
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 50, 2.0)  # Fades in over 2 sec
	await tween.finished
	_show_death_screen()

func _show_death_screen():
	label.show()
	button.show()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes_and_scripts/menu/menu.tscn")
