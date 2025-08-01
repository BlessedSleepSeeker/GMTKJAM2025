extends Node
class_name LevelManager

@export var level_list: Array[PackedScene] = []

signal level_started(number: String)
signal level_finished(level_name: String, collectibles: int)
signal removing_level
signal play_transition(direction: bool)
signal add_player_move(amount: int)
signal remove_player_move(amount: int)
signal ajust_apples(amount: int)

var take_control_from_player: bool = false

var current_level_index: int = 0:
	set(value):
		if value < 0:
			value = level_list.size() - 1
		if value >= level_list.size():
			value = 0
		current_level_index = value

var current_level: Level = null

func _ready():
	load_level()

func load_level() -> void:
	var new_level: Level = level_list[current_level_index].instantiate()
	new_level.finished.connect(progress_level)
	new_level.move_done.connect(add_player_move.emit.bind(1))
	new_level.move_cancelled.connect(remove_player_move.emit.bind(1))
	new_level.currently_eaten_apples.connect(currently_eaten_apples)
	self.call_deferred("add_child", new_level)
	current_level = new_level
	await get_tree().process_frame
	level_started.emit(current_level_index)
	play_transition.emit(false)
	take_control_from_player = false

func remove_level() -> void:
	current_level.queue_free()

func reset_level() -> void:
	take_control_from_player = true
	remove_level()
	load_level()

func progress_level(collectibles: int) -> void:
	take_control_from_player = true
	level_finished.emit(current_level.name, collectibles)
	removing_level.emit()
	await get_tree().create_timer(1.7).timeout
	current_level_index += 1
	remove_level()
	load_level()

func skip_level() -> void:
	removing_level.emit()
	take_control_from_player = true
	current_level_index += 1
	remove_level()
	load_level()

func _unhandled_input(_event):
	if take_control_from_player:
		return
	if Input.is_action_just_pressed("reset"):
		remove_player_move.emit(current_level.total_moves_done)
		reset_level()

func currently_eaten_apples(amount: int) -> void:
	ajust_apples.emit(amount)
