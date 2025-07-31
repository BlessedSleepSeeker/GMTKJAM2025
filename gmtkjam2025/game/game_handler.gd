extends Node
class_name GameHandler

@onready var level_manager: LevelManager = $LevelManager
@onready var hud: GameHUD = %GameHud

var total_level: int = 0
var total_apples: int = 0
var total_moves: int = 0

func _ready():
	level_manager.level_finished.connect(on_level_finished)
	level_manager.add_player_move.connect(add_moves)
	level_manager.remove_player_move.connect(remove_moves)
	level_manager.ajust_apples.connect(ajust_apples)

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