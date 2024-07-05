extends Node

@onready var CardScene: PackedScene = preload("res://scenes/CardScene.tscn")

const PLAYER_CARD_SIZE = 15 # Value indicating how many numbers should be on the player's card
const PLAYER_CARD_FONT_SIZE = 16 # Font size for the numbers in the player's card
const CHECKLIST_FONT_SIZE = 16 # Font size for the numbers in the checklist
const ANIMATION_TIMER = 2 # Animation timespan

const COLORS = {
	BLUE = Color(0,0,1), # 1,10
	RED = Color(1,0,0), # 11, 20
	GREEN = Color(0,1,0), # 21, 30
	AQUA = Color(0,1,1), # 31, 40
	YELLOW = Color(1,1,0), # 41, 50
	MAGENTA = Color(1,0,1), # 51, 60
	PURPLE = Color(0.3,0.3,0.5), # 61, 70
	BLACK = Color(0,0,0), # 71, 80
	GREY = Color(0.5,0.5,0.5), # 81, 90
	BROWN = Color(0.62, 0.33, 0.17) # 91, 100
}

var BALL_RANGE = 60 # Default value for the total amount of possible balls
var BALL_EXTRACTION_RANGE = 30 # Default value for the amount of balls to extract
var BET_AMOUNT: float = 1 # Default bet amount
var WINNINGS: float = 0 # Default value for amount won at the end of the game

var randomized_balls = [] # Shuffled list of values representing the ball extraction succession
var extracted_balls = [] # List of values representing the balls that were already extracted
var player_card_array: Array # List of objects representing the numbers on the player card
var checklist_numbers_array: Array # List of objects representing checklist numbers
var player_grid_dimensions: Vector2 # Player card grid dimensions
var checklist_dimensions: Vector2 # Checklist dimensions

# Randomize order for balls to be extracted
func randomize_balls_to_extract() -> Array:
	randomized_balls = range(1, BALL_RANGE + 1)
	randomized_balls.shuffle()
	
	# Reset the list of balls that were already extracted
	extracted_balls = []
	
	return randomized_balls

func create_checklist(gridContainer: GridContainer):
	checklist_dimensions = Vector2(ceil(AutoloadHelper.BALL_RANGE / 5), 5)
	checklist_numbers_array = create_grid_array(BALL_RANGE - 1, checklist_dimensions, BALL_RANGE - 1, range(1, AutoloadHelper.BALL_RANGE + 1), CHECKLIST_FONT_SIZE, gridContainer)

#Randomize player card numbers
func randomize_player_card(gridContainer: GridContainer):
	var player_card_numbers = range(1, BALL_RANGE + 1)
	player_card_numbers.shuffle()
	player_card_numbers = player_card_numbers.slice(0, PLAYER_CARD_SIZE)
	player_card_numbers.sort()
	
	player_grid_dimensions = Vector2(ceil(PLAYER_CARD_SIZE / 5), 5)
	
	player_card_array = create_grid_array(PLAYER_CARD_SIZE, player_grid_dimensions, player_card_numbers.size(), player_card_numbers, 16, gridContainer) 

func create_grid_array(index: int, grid_dimensions: Vector2, size: int, originalArray: Array, fontSize: int, gridContainer: GridContainer) -> Array:
	var temp_grid = []
	
	for i in range(grid_dimensions.x):
		var row = []
		for j in range(grid_dimensions.y):
			if index >= 0 and index <= size:
				row.append(create_number_card(originalArray[size - index], fontSize, gridContainer))
				index -= 1
		temp_grid.append(row)
	
	return temp_grid

# Returns the next ball to be extracted and adds it to collection of extracted balls
func get_next_extraction() -> int:
	var ball = randomized_balls.pop_front()
	extracted_balls.append(ball)
	
	return ball

# Get the appropriate color for the provided number
func calculate_ball_color(number: int) -> Color:
	var colors = COLORS.values()
	var number_color = (number - 1) / 10
	
	return colors[number_color]

# Check if the cards contain the provided number
func check_has_number(number: int, grid_dimensions: Vector2, array: Array) -> bool:
	var result = false
	for i in range(grid_dimensions.x):
		for j in range(grid_dimensions.y):
			var card: PanelContainer = array[i][j]
			if card.get_child(1).text == str(number):
				result = true
				mark_number(number, card)
	return result

func create_number_card(number: int, fontSize: int, grid: GridContainer) -> PanelContainer:
	var new_card: PanelContainer = CardScene.instantiate()
	
	var new_card_rect: TextureRect = new_card.get_child(0)
	var new_card_label: Label = new_card.get_child(1)
	new_card_rect.modulate = AutoloadHelper.calculate_ball_color(number)
	new_card_label["theme_override_font_sizes/font_size"] = fontSize
	new_card_label.text = str(number)

	grid.add_child(new_card)
	return new_card

# Remove all buttons form the grid
func remove_buttons(grid: GridContainer):
	var children = grid.get_children()
	
	for child: Control in children:
		if child.is_in_group("card_button"):
			grid.remove_child(child)
			child.queue_free()

# mark the button on the card as matched
func mark_number(number: int, card: PanelContainer):
		var card_number = card.get_child(1)
		if card.is_in_group("card") and card_number.text == str(number):
			var card_highligther = card.get_child(2)
			card_highligther.visible = true
