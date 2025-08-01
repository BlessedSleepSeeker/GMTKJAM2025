extends Area2D
class_name BaseBoxSpot

signal spot_filled
signal spot_emptied

var has_box_on_it: bool = false 

func _on_area_entered(area:Area2D):
	if area is BaseBox:
		spot_filled.emit()
		has_box_on_it = true

func _on_area_exited(area:Area2D):
	if area is BaseBox:
		spot_emptied.emit()
		has_box_on_it = false
