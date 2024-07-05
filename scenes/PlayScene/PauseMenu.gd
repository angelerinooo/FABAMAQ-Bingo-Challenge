extends Control

@onready var pause_menu: PanelContainer = $PauseMenuPanel

const TitleScreen = "res://scenes/Titlescreen/Titlescreen.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	_hide_pause_menu()

# Hides the pause menu
func _hide_pause_menu():
	pause_menu.hide()
	get_tree().paused = false

# Shows the pause menu
func _show_pause_menu():
	pause_menu.show()
	get_tree().paused = true

# Returns to title screen
func _back_to_titlescreen():
	get_tree().paused = false
	get_tree().change_scene_to_file(TitleScreen)

# Handle 'Pause' button press
func _on_pause_button_pressed():
	_show_pause_menu()

# Handle 'Resume' button press
func _on_resume_button_pressed():
	_hide_pause_menu()

# Handle 'Back' button press
func _on_main_menu_button_pressed():
	_back_to_titlescreen()
