extends Control

@onready var CardScene: PackedScene = preload("res://scenes/CardScene.tscn")
@onready var grid: GridContainer = $PanelTemplate/VBoxContainer/CardGrid

const BUTTON_FONT_SIZE = 16

var checklist_size = AutoloadHelper.BALL_RANGE

func reset():
	checklist_size = AutoloadHelper.BALL_RANGE
	
	AutoloadHelper.remove_buttons(grid)
	
	AutoloadHelper.create_checklist(grid)
