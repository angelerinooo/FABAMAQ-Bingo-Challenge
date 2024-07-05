extends Control

@onready var grid: GridContainer = $PanelTemplate/VBoxContainer/CardGrid

func reset():	
	AutoloadHelper.remove_buttons(grid)
	AutoloadHelper.randomize_player_card(grid)
