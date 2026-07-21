extends Node2D
var sonidoIntro = preload("res://Audio/esc_1-2_mastered.wav") # Debe ser .wav, .ogg o .mp3
var MusicaMenu

func _ready() -> void:
	Dialogic.Inputs.auto_advance.enabled_forced = true
	Dialogic.start("narracion")
	MusicaMenu = $MusicaMenu
	MusicaMenu.stream = sonidoIntro
	MusicaMenu.play()
	$AnimationPlayer.play("FadeIn")
	await get_tree().create_timer(5).timeout
	$AnimationPlayer.play("HISTORIA")
	await get_tree().create_timer(47).timeout
	$AnimationPlayer.play("FadeOut")
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Scenes/MainEscene.tscn") #Aca va la direccion del juego principal
