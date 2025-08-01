extends Area2D
class_name BaseCollectible

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var random_player: RandomStreamPlayer = $RandomStreamPlayer

var current_anim: String = "idle":
	set(value):
		current_anim = value
		play_anim(value)

func play_anim(anim_name: String) -> void:
	sprite.play(anim_name)

func eaten() -> void:
	current_anim = "vanish"
	random_player.play_random()