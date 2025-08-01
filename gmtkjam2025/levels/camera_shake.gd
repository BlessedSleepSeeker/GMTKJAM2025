extends Camera2D
class_name CameraShake

@export var decay = 7
@export var max_offset = Vector2(5, 3)
@export var max_roll = 0.1

var trauma: float = 0.0
var trauma_power: int = 2

func _ready():
	randomize()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)