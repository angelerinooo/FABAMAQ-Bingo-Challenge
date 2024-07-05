extends Control

@onready var end_game_menu: PanelContainer = $EndGamePanel
@onready var winnings_value: Label = $EndGamePanel/MenuItems/HBoxContainer/WinningsValue

const TitleScreen = "res://scenes/Titlescreen/Titlescreen.tscn"
const PlayScene = "res://scenes/PlayScene/PlayScene.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_end_game_menu()

func hide_end_game_menu():
	end_game_menu.hide()

# Shows the pause menu
func show_end_game_menu(value: float):
	winnings_value.text = str(value).pad_decimals(2)
	end_game_menu.show()
	show()

# Returns to title screen
func _back_to_titlescreen():
	get_tree().change_scene_to_file(TitleScreen)

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file(PlayScene)
	hide_end_game_menu()

func _on_main_menu_button_pressed():
	_back_to_titlescreen()
