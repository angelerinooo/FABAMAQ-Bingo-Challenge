extends Control

@export var BallScene: PackedScene = preload("res://scenes/Ball/Ball.tscn")

@onready var balls_wrapper: Node2D = $BallWrapper
@onready var kill_balls_wrapper: Node2D = $KillBallWrapper
@onready var numbers_checklist: Control = $UI/NumbersChecklist
@onready var player_card: Control = $UI/PlayerCard
@onready var end_game_menu: Control = $UI/EndGameMenu
@onready var got_number_asp: AudioStreamPlayer = $Sound/GotNumber
@onready var no_number_asp: AudioStreamPlayer = $Sound/NoNumber

const BALLS_START_POSITION = Vector2(800, 0)
const BALLS_MARGIN = 60
const MAX_BALLS_STACK = 10 # Maximum amoubt of the balls in ball path to be displayed

var missing_extract_ball: int = AutoloadHelper.BALL_EXTRACTION_RANGE # number of balls left to extract
var missing_player_numbers: int = AutoloadHelper.PLAYER_CARD_SIZE # number of player balls left to match

func _ready():
	_reset()
	_new_ball()

# Resets the balls, player card, and all game
func _reset() -> void:
	AutoloadHelper.WINNINGS = 0
	AutoloadHelper.randomize_balls_to_extract()
	player_card.reset()
	numbers_checklist.reset()
	
	missing_extract_ball = AutoloadHelper.BALL_EXTRACTION_RANGE
	missing_player_numbers = AutoloadHelper.PLAYER_CARD_SIZE
	
	got_number_asp.stop()
	no_number_asp.stop()
	
	for ball: Ball in balls_wrapper.get_children():
		balls_wrapper.remove_child(ball)
		ball.queue_free()

# Create a new ball and animate
# Check for ball count to assert the end of the game
func _new_ball() -> void:
	if missing_extract_ball == 0:
		$ExtractionTimer.stop()
		_end_game()
		return
	if missing_player_numbers == 0:
		$ExtractionTimer.stop()
		AutoloadHelper.WINNINGS = AutoloadHelper.WINNINGS + (AutoloadHelper.BET_AMOUNT * 5)
		_end_game()
		return

	if balls_wrapper.get_children().size() >= MAX_BALLS_STACK:
		_move_children_ball()
	
	var new_ball: Ball = BallScene.instantiate()
	var number = AutoloadHelper.get_next_extraction()
	var children = balls_wrapper.get_children()
	
	missing_extract_ball -= 1
	
	new_ball.set_number(number)
	balls_wrapper.add_child(new_ball)
	new_ball.extraction_animation(
		Vector2(BALLS_MARGIN * children.size(), 0),
		BALLS_START_POSITION,
		AutoloadHelper.ANIMATION_TIMER - 0.1 * children.size()
		)
	
	new_ball.animation_finish.connect(_ended_ball_animation.bind(number))

# Opens the end game Pop up
func _end_game() -> void:
	end_game_menu.show_end_game_menu(AutoloadHelper.WINNINGS)
	AutoloadHelper.WINNINGS = 0
	PatternsHelper.reset()

# Move extracted balls to the left and remove left-most ball when maximum stack size is reached 
func _move_children_ball():
	var kill_child = balls_wrapper.get_children()[0]
	kill_child.to_kill = true
	
	for ball: Ball in balls_wrapper.get_children():
		ball.move_side_animation(Vector2(ball.position.x - BALLS_MARGIN, 0))
	
	balls_wrapper.remove_child(kill_child)
	kill_balls_wrapper.add_child(kill_child)

# Play sound and mark on player card
func _ended_ball_animation(number: int) -> void:
	AutoloadHelper.check_has_number(number, AutoloadHelper.checklist_dimensions, AutoloadHelper.checklist_numbers_array)
	
	if AutoloadHelper.check_has_number(number, AutoloadHelper.player_grid_dimensions, AutoloadHelper.player_card_array):
		got_number_asp.play()
		missing_player_numbers -= 1
		PatternsHelper.check_all_patterns(AutoloadHelper.player_card_array)
	else:
		no_number_asp.play()

# Timer for ball extraction
func _on_extraction_timer_timeout():
	_new_ball()
