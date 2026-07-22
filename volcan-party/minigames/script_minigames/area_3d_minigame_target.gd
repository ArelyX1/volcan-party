extends Area3D


func _on_body_entered(body: Node3D) -> void:
	var minigame = preload("res://minigames/osugame/osu_minigame.tscn").instantiate()
	get_tree().current_scene.add_child(minigame)
	minigame.show()
	minigame.get_node("Panel/Game").start_game()
	await get_tree().create_timer(15.0).timeout
	minigame.queue_free()
