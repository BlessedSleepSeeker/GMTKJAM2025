extends Node
class_name GameHandler

@export_range(0.1, 10, 0.1) var transition_speed: float = 3

@onready var level_manager: LevelManager = $LevelManager
@onready var hud: GameHUD = %GameHud
@onready var debug_hud: DebugHUD = %DebugHud
@onready var transition_rect: ColorRect = %TransitionRect

var total_level: int = 0
var total_apples: int = 0
var total_moves: int = 0

func _ready():
	level_manager.level_started.connect(update_level)
	level_manager.level_finished.connect(on_level_finished)
	level_manager.removing_level.connect(transition.bind(true))
	level_manager.play_transition.connect(transition)
	level_manager.add_player_move.connect(add_moves)
	level_manager.remove_player_move.connect(remove_moves)
	level_manager.ajust_apples.connect(ajust_apples)

func update_level(number: int) -> void:
	hud.update_level(number + 1)
	debug_hud.register_spots()

func on_level_finished(_level_name: String, collectibles: int) -> void:
	total_apples += collectibles
	total_level += 1
	hud.update_wins(total_level)
	hud.update_apples(total_apples)

func ajust_apples(amount: int) -> void:
	hud.update_apples(total_apples + amount)

func add_moves(amount: int) -> void:
	total_moves += amount
	hud.update_moves(total_moves)

func remove_moves(amount: int) -> void:
	total_moves -= amount
	hud.update_moves(total_moves)

func transition(direction: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(transition_rect.material, "shader_parameter/progress", 1 if direction else 0, transition_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
