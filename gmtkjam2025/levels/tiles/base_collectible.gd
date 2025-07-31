extends Area2D
class_name BaseCollectible

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_anim: String = "idle":
	set(value):
		current_anim = value
		play_anim(value)

func play_anim(anim_name: String) -> void:
	sprite.play(anim_name)

func eaten() -> void:
	current_anim = "vanish"