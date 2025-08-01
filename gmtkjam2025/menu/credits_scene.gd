extends MarginContainer
class_name CreditScene

@export var button_base_color: Color
@export var button_hover_color: Color
@export var button_hover_tween_time: float = 1

@export var main_menu_scene_path: String = "res://menu/MainMenu.tscn"

@onready var back: Button = %Return

func _ready():
	back.grab_focus()

func _on_return_pressed():
	get_tree().change_scene_to_file(main_menu_scene_path)


func tween_button_color(button: Button, direction: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate", button_hover_color if direction else button_base_color, button_hover_tween_time)


func _on_return_focus_exited():
	tween_button_color(back, false)


func _on_return_focus_entered():
	tween_button_color(back, true)
