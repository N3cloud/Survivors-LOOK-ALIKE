extends Control

var level = "res://Mundo/mundo.tscn"




func _on_button_jugar_click_end() -> void:
	var _level = get_tree().change_scene_to_file(level)


func _on_button_salir_click_end() -> void:
	get_tree().quit()
