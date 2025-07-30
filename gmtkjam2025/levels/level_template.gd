extends Node2D
class_name Level

@onready var snake_head: SnakeHead = %SnakeHead
@onready var camera: CameraShake = $CameraShake
@onready var snake_parts: Node2D = $SnakeParts

@export var snake_head_scene: PackedScene = preload("res://player/head/SnakeHead.tscn")

var state_history: Array[PackedScene] = []
var position_history: Array[Vector2] = []
var direction_history: Array[String] = []
var head_history: Array[Dictionary] = []

func _ready():
	snake_head.spawn_body.connect(spawn_body)
	snake_head.save_move.connect(save_state)
	snake_head.impossible_move.connect(on_impossible_move)


func spawn_body(scene: PackedScene, _position: Vector2, _rotation: float, _turning: String) -> void:
	var inst: SnakeBody = scene.instantiate()
	snake_parts.add_child(inst)
	inst.position = _position
	inst.set_sprite_rotation(_rotation)
	inst.set_turn(_turning)

func on_impossible_move(strenght: float) -> void:
	camera.add_trauma(strenght)


func save_state(_direction: String, _position: Vector2) -> void:
	var save = PackedScene.new()
	for child in snake_parts.get_children():
		child.set_owner(snake_parts)
		for child2 in child.get_children():
			child2.set_owner(snake_parts)
	save.pack(snake_parts)
	state_history.push_back(save)

	var saved_snake_head: Dictionary = {}
	for variable in snake_head.get_property_list():
		var value = snake_head.get(variable["name"])
		saved_snake_head[variable["name"]] = value
	head_history.push_back(saved_snake_head)
	#direction_history.push_back(_direction)
	#position_history.push_back(_position)

func cancel_last_move() -> void:
	if state_history.size() > 0:
		var saved_state = state_history.pop_back()
		snake_parts.queue_free()
		await snake_parts.tree_exited
		snake_parts = saved_state.instantiate()
		add_child(snake_parts)

		var saved_head = head_history.pop_back()
		for variable in saved_head:
			snake_head.set(variable, saved_head[variable])
		#snake_head.position = position_history.pop_back()
		#snake_head.rotate_sprite(direction_history.pop_back())

func _unhandled_input(event):
	if Input.is_action_just_pressed("cancel"):
		cancel_last_move()
