extends Control

# var sonidoMenu = preload("res://Audio/menu_remastered.wav")
var MusicaMenu

func _ready():
	# MusicaMenu = $MusicaMenu  # Encuentra el nodo recién agregado
	# MusicaMenu.stream = sonidoMenu
	# MusicaMenu.play()
	pass
func _on_button_pressed() -> void:
	# MusicaMenu.stop()
	get_tree().change_scene_to_file("res://Scenes/MainEscene.tscn")

func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/opciones.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
