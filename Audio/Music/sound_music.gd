extends AudioStreamPlayer


func _on_jugador_player_death() -> void:
	playing = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
