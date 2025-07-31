extends TextureRect
class_name AnimatedRect

@export var frames: Array[Texture]
@export var frame_delay: float = 1.0

@onready var timer: Timer = $Timer

var current_texture_index: int = 0:
	set(value):
		if value < 0:
			value = frames.size() - 1
		if value >= frames.size():
			value = 0
		current_texture_index = value
		self.texture = frames[current_texture_index]

func _ready():
	current_texture_index = 0
	play_animation()


func play_animation() -> void:
	current_texture_index = 0
	timer.wait_time = frame_delay
	timer.timeout.connect(increment_index)
	timer.start()

func pause_animation() -> void:
	timer.stop()

func increment_index() -> void:
	current_texture_index += 1

	
	