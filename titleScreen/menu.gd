extends Control

var pantalla_compras = "res://Utilidades/pantalla_mejoras.tscn"




func _on_button_jugar_click_end() -> void:
	var _level = get_tree().change_scene_to_file(pantalla_compras)


func _on_button_salir_click_end() -> void:
	get_tree().quit()
