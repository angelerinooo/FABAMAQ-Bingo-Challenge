extends MarginContainer

const PlayScene = "res://scenes/PlayScene/PlayScene.tscn"
const SettingsMenuScene = "res://scenes/SettingsMenu/SettingsMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Handle 'Play' button press
func _on_play_button_pressed():
	get_tree().change_scene_to_file(PlayScene)

# Handle 'Settings' button press
func _on_settings_button_pressed():
	get_tree().change_scene_to_file(SettingsMenuScene)

# Handle 'Exit' button press
func _on_exit_button_pressed():
	get_tree().quit()
