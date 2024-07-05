extends Control

@onready var number_label: Label = $SettingsVBox/NumberLabel
@onready var max_ball_slider: HSlider = $SettingsVBox/MaxBallSlider
@onready var extractions_label: Label = $SettingsVBox/ExtractionsNumberLabel
@onready var max_extractions_slider: HSlider = $SettingsVBox/MaxExtractionsSlider

const TITLESCREEN_SCENE: String = "res://scenes/Titlescreen/Titlescreen.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	number_label.text = str(AutoloadHelper.BALL_RANGE)
	max_ball_slider.value = AutoloadHelper.BALL_RANGE
	
	extractions_label.text = str(AutoloadHelper.BALL_EXTRACTION_RANGE)
	max_extractions_slider.value = AutoloadHelper.BALL_EXTRACTION_RANGE

# Handle slider value changes
func _on_max_ball_slider_value_changed(value):
	number_label.text = str(value)

func _on_max_extractions_slider_value_changed(value):
	extractions_label.text = str(value)
	max_extractions_slider.max_value = max_ball_slider.value
	
# Save the value on the slider as the new maximum range for ball generation
func _on_save_exit_button_pressed():	
	AutoloadHelper.BALL_RANGE = max_ball_slider.value
	AutoloadHelper.BALL_EXTRACTION_RANGE = max_extractions_slider.value
	get_tree().change_scene_to_file(TITLESCREEN_SCENE)
