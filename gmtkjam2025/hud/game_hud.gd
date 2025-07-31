extends MarginContainer
class_name GameHUD

@export_multiline var wins_template: String = ""
@export_multiline var apples_template: String = ""
@export_multiline var moves_template: String = ""

@onready var wins: RichTextLabel = %Wins
@onready var apples: RichTextLabel = %Collectibles
@onready var moves: RichTextLabel = %Moves

func update_wins(amount: int) -> void:
	wins.text = wins_template % amount

func update_apples(amount: int) -> void:
	apples.text = apples_template % amount

func update_moves(amount: int) -> void:
	moves.text = moves_template % amount