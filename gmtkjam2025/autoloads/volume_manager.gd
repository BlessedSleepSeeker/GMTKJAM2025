extends Node

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle_sfx"):
		var bus = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_mute(bus, not AudioServer.is_bus_mute(bus))
	if Input.is_action_just_pressed("toggle_bgm"):
		var bus = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_mute(bus, not AudioServer.is_bus_mute(bus))