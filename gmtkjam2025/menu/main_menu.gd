extends MarginContainer
class_name MainMenu

@export var play_scene: PackedScene = preload("res://game/GameHandler.tscn")
@export var credits_scene: PackedScene = preload("res://menu/CreditsScene.tscn")

@export var title_color_1: Color
@export var title_color_2: Color
@export var title_tween_time: float = 20

@export var button_base_color: Color
@export var button_hover_color: Color
@export var button_hover_tween_time: float = 0.3

@onready var title: RichTextLabel = %Title
@onready var play: Button = %Play
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit

func _ready():
	title.modulate = title_color_1
	tween_title_color(true)
	play.grab_focus()


func tween_title_color(direction: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(title, "modulate", title_color_2 if direction else title_color_1, title_tween_time)
	tween.finished.connect(tween_title_color.bind(!direction), CONNECT_ONE_SHOT)

func tween_button_color(button: Button, direction: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate", button_hover_color if direction else button_base_color, button_hover_tween_time)


func _on_quit_pressed():
	quit.release_focus()
	get_tree().quit()


func _on_credits_pressed():
	credits.release_focus()
	get_tree().change_scene_to_packed(credits_scene)


func _on_play_pressed():
	play.release_focus()
	get_tree().change_scene_to_packed(play_scene)


func _on_play_focus_entered():
	tween_button_color(play, true)


func _on_play_focus_exited():
	tween_button_color(play, false)


func _on_credits_focus_entered():
	tween_button_color(credits, true)


func _on_credits_focus_exited():
	tween_button_color(credits, false)


func _on_quit_focus_exited():
	tween_button_color(quit, false)


func _on_quit_focus_entered():
	tween_button_color(quit, true)
