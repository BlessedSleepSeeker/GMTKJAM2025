extends Area2D
class_name BaseBox

@export var tile_size: float = 16
@export var move_animation_speed: float = 0.1
@export var push_delay: float = 0.05

@onready var deny_raycast: RayCast2D = $DenyRaycast
@onready var push_raycast: RayCast2D = $PushRaycast

var self_history: Array[Dictionary] = []

var directions = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN}

func can_be_pushed(direction: String) -> bool:
	deny_raycast.target_position = directions[direction] * tile_size
	deny_raycast.force_raycast_update()
	push_raycast.target_position = directions[direction] * tile_size
	push_raycast.force_raycast_update()

	if deny_raycast.is_colliding():
		return false
	elif push_raycast.is_colliding():
		return push_raycast.get_collider().can_be_pushed(direction)
	else:
		return true

func push(direction: String) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", position + directions[direction] * tile_size, move_animation_speed).set_trans(Tween.TRANS_CUBIC)
	if push_raycast.is_colliding():
		var collider: BaseBox = push_raycast.get_collider()
		#await get_tree().create_timer(push_delay).timeout
		collider.push(direction)
