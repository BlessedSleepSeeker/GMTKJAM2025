extends MarginContainer
class_name DebugHUD

@onready var spot_ok: Label = %SpotOK
@onready var prev_dir: Label = %PrevDir

var spot_value: int = 0:
	set(value):
		spot_value = value
		update_spot(value)

func register_spots():
	spot_value = 0
	for i: BaseBoxSpot in get_tree().get_nodes_in_group("box_spot"):
		if not i.spot_filled.is_connected(increment_spot):
			i.spot_filled.connect(increment_spot)
		if not i.spot_emptied.is_connected(decrement_spot):
			i.spot_emptied.connect(decrement_spot)
		if i.has_box_on_it:
			increment_spot()
	update_spot(spot_value)

func increment_spot() -> void:
	spot_value += 1

func decrement_spot() -> void:
	spot_value -= 1

func update_spot(amount: int) -> void:
	spot_ok.text = "%d" % amount

func update_prev_dir(dir: String) -> void:
	prev_dir.text = dir

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_debug"):
		self.visible = !self.visible