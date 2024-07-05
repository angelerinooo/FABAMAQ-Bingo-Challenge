extends Node2D

class_name Ball

signal animation_finish

@onready var ball_sprite: Sprite2D = $BallSprite
@onready var number_label: Label = $Number

var ball_number: int
var ball_color: Color = Color(0, 0, 0)
var tween: Tween
var to_kill = false

func _ready():
	ball_sprite.modulate = ball_color
	number_label.text = str(ball_number)

# Sets the number and its respective color
func set_number(number: int):
	ball_number = number
	ball_color = AutoloadHelper.calculate_ball_color(number)

# Executes the extraction animation
# Moves the ball from the right to the left
# When the ball is in the right position, plays another animation for scaling
func extraction_animation(end_position: Vector2, start_position: Vector2 = position, time: float = 3) -> void:
	position = start_position
	tween = create_tween()
	scale = Vector2(1.5, 1.5)
	
	tween.tween_property(self, "position", end_position, time / 2)
	tween.parallel().tween_property(self, "scale", Vector2(2, 2), time / 6)
	
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), time / 6)
	tween.finished.connect(_animation_finish)

# Emit the signal for the end of the ball animation
func _animation_finish() -> void:
	animation_finish.emit()

# Moves the ball to the left
# If it is the last ball, plays the kill animation
func move_side_animation(end_position: Vector2, time: float = 1) -> void:
	tween = create_tween()
	tween.tween_property(self, "position", end_position, time / 2)
	
	if to_kill:
		tween.parallel().tween_property(self, "scale", Vector2(0, 0), time / 6)
		tween.parallel().tween_property(self, "modulate", Color(1,1,1,0), time / 6)
		tween.tween_callback(_kill)

# Remove ball from the scene and from the ball wrapper
func _kill() -> void:
	get_parent().remove_child(self)
	queue_free()
