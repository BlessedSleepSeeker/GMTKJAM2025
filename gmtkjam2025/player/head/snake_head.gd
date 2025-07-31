extends Area2D
class_name SnakeHead


@export var snake_body_scene: PackedScene = preload("res://player/body/SnakeBody.tscn")
@export var tile_size: int = 16

@export var move_animation_speed: float = 0.1

@export var screen_shake_on_impossible_move: float = 2.5

@onready var sprite: Sprite2D = $Sprite
@onready var obstacle_ray: RayCast2D = $ObstacleRayCast
@onready var push_ray: RayCast2D = $PushRayCast

signal spawn_body(body_scene: PackedScene, position: Vector2, rotation: float, direction: String)
signal impossible_move(strenght: float)
signal save_move(direction: String)
signal ate_tail
signal ate_collectible

var movement_actions = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN}

var rotation_values = {
	"up": 0,
	"right": 90,
	"left": -90,
	"down": 180
}

var sprite_rotation: String = "up":
	set(value):
		sprite_rotation = value
		rotate_sprite(value)
var previous_direction: String = "up"
var turn: String = ""

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position.x -= Vector2.ONE.x * tile_size / 2
	position.y += Vector2.ONE.y * tile_size / 2

var is_moving: bool = false
func _unhandled_input(_event):
	for action in movement_actions:
		if Input.is_action_pressed(action) && not is_moving:
			move(action)


func move(direction: String) -> void:
		if not check_move(direction):
			impossible_move.emit(screen_shake_on_impossible_move)
			return
		if check_push(direction):
			push(direction)
		else:
			impossible_move.emit(screen_shake_on_impossible_move)
			return
		save_move.emit(previous_direction, position)
		if direction != previous_direction:
			set_turn(direction)
		else:
			turn = "straight"
		spawn_body.emit(snake_body_scene, self.position, sprite.rotation_degrees, turn)
		sprite_rotation = direction
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + movement_actions[direction] * tile_size, move_animation_speed).set_trans(Tween.TRANS_CUBIC)
		is_moving = true
		previous_direction = direction
		await tween.finished
		is_moving = false

func check_move(direction: String) -> bool:
	obstacle_ray.target_position = movement_actions[direction] * tile_size
	obstacle_ray.force_raycast_update()
	if obstacle_ray.is_colliding():
		return false
	return true

func check_push(direction: String) -> bool:
	push_ray.target_position = movement_actions[direction] * tile_size
	push_ray.force_raycast_update()
	if push_ray.is_colliding():
		print("colliding")
		return push_ray.get_collider().can_be_pushed(direction)
	#if we reach here, this is a bug
	return true

func push(direction: String) -> void:
	if push_ray.is_colliding():
		push_ray.get_collider().push(direction)

func rotate_sprite(direction: String):
	sprite.rotation_degrees = rotation_values[direction]

func set_turn(direction: String) -> void:
	if previous_direction == "up":
		if direction == "right":
			turn = direction
		if direction == "left":
			turn = direction
	if previous_direction == "down":
		if direction == "right":
			turn = "left"
		if direction == "left":
			turn = "right"
	if previous_direction == "left":
		if direction == "up":
			turn = "right"
		if direction == "down":
			turn = "left"
	if previous_direction == "right":
		if direction == "up":
			turn = "left"
		if direction == "down":
			turn = "right"


func _on_area_entered(area: Area2D) -> void:
	if area is SnakeTail:
		ate_tail.emit()
	if area is BaseCollectible:
		ate_collectible.emit()
		area.eaten()
