extends Control

@onready var gold_label = $VBoxContainer3/OroLabel
@onready var velocidad_mejora_btn = $VBoxContainer/MejorarButton
@onready var salud_mejora_btn = $VBoxContainer2/MejorarButton
@onready var comenzar_partida_btn = $VBoxContainer4/ComenzarButton
var level = "res://Mundo/mundo.tscn"
var oro_disponible = 0
var velocidad_mejorada = 0
var salud_maxima_mejorada = 0

func _ready():
	cargar_mejoras()
	load_gold()  # Cargar el oro desde el archivo al Global
	actualizar_oro_label()
	
func save_gold():
	var file = FileAccess.open("user://gold_save.dat", FileAccess.WRITE)
	file.store_var(Global.oro_disponible)  # Guarda el oro actual
	file.close()

# Función para cargar el oro desde un archivo
func load_gold():
	var file = FileAccess.open("user://gold_save.dat", FileAccess.READ)
	if file:
		Global.oro_disponible = file.get_var()  # Carga la cantidad de oro
		file.close()
	else:
		Global.oro_disponible = 0  # Si no existe el archivo, inicializa con 0 oro

# Función para actualizar la etiqueta del oro disponible
func actualizar_oro_label():
	gold_label.text = "Oro: " + str(Global.oro_disponible)

# Función para comprar la mejora de velocidad
func _on_Velocidad_MejorarButton_pressed():
	var costo = 250  # Definir el costo de la mejora de velocidad
	if Global.oro_disponible >= costo and velocidad_mejorada < 5:  # Limitar a 5 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		velocidad_mejorada += 1  # Aumentar las mejoras de velocidad
		Global.velocidad_mejorada += 1  # Aumentar las mejoras de velocidad en Global
		guardar_mejoras()  # Asegúrate de guardar las mejoras aquí
		actualizar_oro_label()  # Actualizar la etiqueta
	else:
		print("No puedes mejorar más la velocidad o no tienes suficiente oro.")  # Mensaje si no se puede mejorar más


# Función para comprar la mejora de salud máxima
func _on_SaludMaxima_MejorarButton_pressed():
	var costo = 300  # Definir el costo de la mejora de salud
	if Global.oro_disponible >= costo and salud_maxima_mejorada < 5:  # Limitar a 5 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		salud_maxima_mejorada += 1  # Aumentar las mejoras de salud
		Global.salud_maxima_mejorada += 1  # Aumentar las mejoras de salud en Global
		guardar_mejoras()  # Asegúrate de guardar las mejoras aquí
		actualizar_oro_label()  # Actualizar la etiqueta
	else:
		print("No puedes mejorar más la salud máxima o no tienes suficiente oro.")  # Mensaje si no se puede mejorar más

# Función para iniciar la partida
func _on_ComenzarButton_pressed():
	# Guardar las mejoras y comenzar la partida
	guardar_mejoras()
	# Cambiar a la escena de juego
	get_tree().change_scene_to_file(level)
	
func cargar_mejoras():
	var file = FileAccess.open("user://mejoras_save.dat", FileAccess.READ)
	if file:
		var data = file.get_var()
		print("Cargando mejoras:", data)
		Global.velocidad_mejorada = data.get("velocidad_mejorada", 0)  # Cargar y asignar a las variables globales
		Global.salud_maxima_mejorada = data.get("salud_maxima_mejorada", 0)  # Cargar y asignar a las variables globales
		file.close()
	else:
		print("Archivo de mejoras no encontrado, inicializando valores por defecto.")
		Global.velocidad_mejorada = 0
		Global.salud_maxima_mejorada = 0

# Función para guardar las mejoras seleccionadas antes de la partida
func guardar_mejoras():
	var file = FileAccess.open("user://mejoras_save.dat", FileAccess.WRITE)
	var data = {
		"velocidad_mejorada": Global.velocidad_mejorada,  # Usar Global
		"salud_maxima_mejorada": Global.salud_maxima_mejorada  # Usar Global
	}
	file.store_var(data)
	file.close()
	# Guardar oro restante
	save_gold()
	# Aquí podrías guardar las mejoras de velocidad y salud en un archivo o en un nodo de jugador

func _on_TestButton_pressed():
	Global.oro_disponible += 1000  # Incrementa el oro en 1000
	velocidad_mejorada += 1  # Incrementa las mejoras de velocidad
	salud_maxima_mejorada += 1  # Incrementa las mejoras de salud
	save_gold()  # Guarda el nuevo valor de oro
	actualizar_oro_label()  # Actualiza la etiqueta para mostrar el nuevo oro
