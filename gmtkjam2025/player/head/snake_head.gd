extends Area2D
class_name SnakeHead


@export var snake_body_scene: PackedScene = preload("res://player/body/SnakeBody.tscn")
@export var tile_size: int = 16

@export var move_animation_speed: float = 0.1

@export var screen_shake_on_impossible_move: float = 2.5

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var obstacle_ray: RayCast2D = $ObstacleRayCast
@onready var push_ray: RayCast2D = $PushRayCast
@onready var tail_ray: RayCast2D = $TailRayCast
@onready var portal_ray: RayCast2D = $PortalRayCast
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var moving_audio: RandomStreamPlayer = $RandomMovePlayer
@onready var tail_audio: AudioStreamPlayer = $TailAudioPlayer

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

@export var sprite_rotation: String = "up":
	set(value):
		sprite_rotation = value
		rotate_sprite(value)
@export var previous_direction: String = "up"
@export var turn: String = ""

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position.x -= Vector2.ONE.x * tile_size / 2
	position.y += Vector2.ONE.y * tile_size / 2


var take_control_from_player: bool = false
var is_moving: bool = false
func _unhandled_input(_event):
	if take_control_from_player:
		return
	for action in movement_actions:
		if Input.is_action_pressed(action) && not is_moving:
			move(action)

@export var portal_movement: bool = false
func move(direction: String) -> void:
		if not check_move(direction):
			impossible_move.emit(screen_shake_on_impossible_move)
			return
		if not check_tail(direction):
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
		if portal_movement:
			portal_ray.get_collider().traverse(self)
			portal_movement = false
		else:
			moving_audio.play_random()
			sprite_rotation = direction
			previous_direction = direction
			var tween: Tween = create_tween()
			tween.tween_property(self, "position", position + movement_actions[direction] * tile_size, move_animation_speed).set_trans(Tween.TRANS_CUBIC)
			is_moving = true
			await tween.finished
			is_moving = false

func check_move(direction: String) -> bool:
	portal_ray.target_position = movement_actions[direction] * tile_size
	portal_ray.force_raycast_update()
	if portal_ray.is_colliding():
		return check_portal()
	obstacle_ray.target_position = movement_actions[direction] * tile_size
	obstacle_ray.force_raycast_update()
	if obstacle_ray.is_colliding():
		return false
	return true

func check_push(direction: String) -> bool:
	push_ray.target_position = movement_actions[direction] * tile_size
	push_ray.force_raycast_update()
	if push_ray.is_colliding():
		return push_ray.get_collider().can_be_pushed(direction)
	#if we reach here, this is a bug
	return true

func check_tail(direction: String) -> bool:
	tail_ray.target_position = movement_actions[direction] * tile_size
	tail_ray.force_raycast_update()
	if tail_ray.is_colliding():
		return check_if_boxes_on_spot()
	return true

func check_portal() -> bool:
	if portal_ray.get_collider().can_be_traversed():
		portal_movement = true
		return true
	return false


func get_spots() -> Array:
	return get_tree().get_nodes_in_group("box_spot")

func check_if_boxes_on_spot() -> bool:
	for spot: BaseBoxSpot in get_spots():
		if not spot.has_box_on_it:
			return false
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
		take_control_from_player = true
		tail_audio.play()
		animation_player.play("victory")
		ate_tail.emit()
	if area is BaseCollectible:
		ate_collectible.emit()
		area.eaten()
