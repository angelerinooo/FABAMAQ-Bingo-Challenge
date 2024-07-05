extends Node

# All horizontal patterns template
const HORIZONTAL_PATTERNS = [
	[[0, 0], [0, 1], [0, 2], [0, 3], [0, 4]],
	[[1, 0], [1, 1], [1, 2], [1, 3], [1, 4]],
	[[2, 0], [2, 1], [2, 2], [2, 3], [2, 4]]
]
# All vertical patterns template
const VERTICAL_PATTERNS = [
	[[0, 0], [1, 0], [2, 0]],
	[[0, 1], [1, 1], [2, 1]],
	[[0, 2], [1, 2], [2, 2]],
	[[0, 3], [1, 3], [2, 3]],
	[[0, 4], [1, 4], [2, 4]]
]
# Up & down arrow patterns template
const ARROW_PATTERNS = [
	[[0, 0], [1, 1], [2, 2], [1, 3], [0, 4]],
	[[2, 0], [1, 1], [0, 2], [1, 3], [2, 4]]
]
# Plus pattern template
const PLUS_PATTERN = [
	[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [0, 2], [2, 2]
]

# All patterns duplicate for handling
var horizontal_patterns: Array
var vertical_patterns: Array
var arrow_patterns: Array
var plus_pattern: Array
var pattern_index: int
var remove_on_index: Array

func _ready():
	reset()

func reset():
	pattern_index = 0
	remove_on_index.clear()
	horizontal_patterns = HORIZONTAL_PATTERNS.duplicate()
	vertical_patterns = VERTICAL_PATTERNS.duplicate()
	arrow_patterns = ARROW_PATTERNS.duplicate()
	plus_pattern = PLUS_PATTERN.duplicate()

func check_all_patterns(player_card: Array):
	for pattern in horizontal_patterns:
		if check_pattern(pattern, player_card):
			remove_on_index.append(pattern_index)
		pattern_index += 1
	
	if remove_on_index.size() > 0:
		remove_pattern_on_index(remove_on_index, horizontal_patterns, 1.5)
	
	for pattern in vertical_patterns:
		if check_pattern(pattern, player_card):
			remove_on_index.append(pattern_index)
		pattern_index += 1
	
	if remove_on_index.size() > 0:
		remove_pattern_on_index(remove_on_index, vertical_patterns, 1.25)
	
	for pattern in arrow_patterns:
		if check_pattern(pattern, player_card):
			remove_on_index.append(pattern_index)
		pattern_index += 1
	
	if remove_on_index.size() > 0:
		remove_pattern_on_index(remove_on_index, arrow_patterns, 2.5)
	
	if check_pattern(plus_pattern, player_card):
		AutoloadHelper.WINNINGS = AutoloadHelper.WINNINGS + (AutoloadHelper.BET_AMOUNT * 3)
		plus_pattern.remove_at(0)

# Method to check the player card for matches with the specified pattern
func check_pattern(pattern: Array, player_card: Array) -> bool:
	for pos in pattern:
		var row = pos[0]
		var col = pos[1]
		row = player_card[row]
		var highlighter: TextureRect = row[col].get_child(2)
		var number = row[col].get_child(1).text
		if not highlighter.is_visible():
			return false
			
	return true

func remove_pattern_on_index(indexes: Array, patterns: Array, multiplier: float):
	for i in range(indexes.size()):
		AutoloadHelper.WINNINGS = AutoloadHelper.WINNINGS + (AutoloadHelper.BET_AMOUNT * multiplier)
		patterns.remove_at(indexes[i])
	
	pattern_index = 0
	remove_on_index.clear()
