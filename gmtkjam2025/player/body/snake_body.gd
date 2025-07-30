extends Area2D
class_name SnakeBody


@onready var sprite_straight: Sprite2D = $SpriteStraight
@onready var sprite_right: Sprite2D = $SpriteRight
@onready var sprite_left: Sprite2D = $SpriteLeft

func set_turn(turn: String) -> void:
	if turn == "straight":
		sprite_straight.show()
		sprite_right.hide()
		sprite_left.hide()
	elif turn == "right":
		sprite_right.show()
		sprite_straight.hide()
		sprite_left.hide()
	elif turn == "left":
		sprite_left.show()
		sprite_right.hide()
		sprite_straight.hide()

func set_sprite_rotation(_rotation: float) -> void:
	self.rotation_degrees = _rotation