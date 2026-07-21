extends Node2D

var master_bus_index = AudioServer.get_bus_index("Master")


func _on_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))
