extends Area3D


func _on_body_entered(body: Node3D) -> void:
	var minigame = preload("res://minigames/osugame/osu_minigame.tscn").instantiate()
	get_tree().current_scene.add_child(minigame)
	minigame.show()
	await get_tree().create_timer(10.0).timeout
	minigame.queue_free()
