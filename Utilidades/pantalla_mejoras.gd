extends Control

@onready var gold_label = $VBoxContainer3/OroLabel
@onready var velocidad_mejora_btn = $VBoxContainer/MejorarButton
@onready var salud_mejora_btn = $VBoxContainer2/MejorarButton
@onready var regen_mejora_btn = $VBoxContainerRegen/MejorarButton
@onready var armor_mejora_btn = $VBoxContainerArmor/MejorarButton
@onready var scroll_mejora_btn = $VBoxContainerScroll/MejorarButton
@onready var ring_mejora_btn = $VBoxContainerRing/MejorarButton
@onready var velocidad_label = $VBoxContainer/LabelVelocidad
@onready var salud_label =  $VBoxContainer2/LabelSalud
@onready var regeneracion_label = $VBoxContainerRegen/LabelRegen
@onready var armadura_label = $VBoxContainerArmor/LabelArmor
@onready var enfriamiento_hechizo_label = $VBoxContainerScroll/LabelScroll
@onready var ataques_adicionales_label = $VBoxContainerRing/LabelRing
@onready var comenzar_partida_btn = $VBoxContainer4/ComenzarButton
var level = "res://Mundo/mundo.tscn"
var oro_disponible = 0
var velocidad_mejorada = 0
var salud_maxima_mejorada = 0
var regeneracion_mejorada = 0
var armadura_mejorada = 0
var enfriamiento_hechizo_mejorado = 0
var ataques_adicionales_mejorado = 0

func _ready():
	cargar_mejoras()
	load_gold()  # Cargar el oro desde el archivo al Global
	actualizar_oro_label()
	actualizar_velocidad_label()  # Actualizar el label de velocidad al iniciar
	actualizar_salud_label()  # Actualizar el label de salud máxima al iniciar
	actualizar_regeneracion_label()
	actualizar_armadura_label()
	actualizar_enfriamiento_hechizo_label()
	actualizar_ataques_adicionales_label()
	
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
	if Global.oro_disponible >= costo and Global.velocidad_mejorada < 5:  # Limitar a 5 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		velocidad_mejorada += 1  # Aumentar las mejoras de velocidad
		Global.velocidad_mejorada += 1  # Aumentar las mejoras de velocidad en Global
		guardar_mejoras()  # Asegúrate de guardar las mejoras aquí
		actualizar_oro_label()  # Actualizar la etiqueta
		actualizar_velocidad_label()  # Actualiza el label de la velocidad
	else:
		print("No puedes mejorar más la velocidad o no tienes suficiente oro.")  # Mensaje si no se puede mejorar más


# Función para comprar la mejora de salud máxima
func _on_SaludMaxima_MejorarButton_pressed():
	var costo = 300  # Definir el costo de la mejora de salud
	if Global.oro_disponible >= costo and Global.salud_maxima_mejorada < 5:  # Limitar a 5 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		salud_maxima_mejorada += 1  # Aumentar las mejoras de salud
		Global.salud_maxima_mejorada += 1  # Aumentar las mejoras de salud en Global
		guardar_mejoras()  # Asegúrate de guardar las mejoras aquí
		actualizar_oro_label()  # Actualizar la etiqueta
		actualizar_salud_label()  # Actualiza el label de la salud máxima
	else:
		print("No puedes mejorar más la salud máxima o no tienes suficiente oro.")  # Mensaje si no se puede mejorar más

func _on_Regeneracion_MejorarButton_pressed():
	var costo = 200  # Definir el costo de la mejora de regeneración
	if Global.oro_disponible >= costo and Global.regeneracion_mejorada < 5:  # Limitar a 5 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		regeneracion_mejorada += 1  # Aumentar las mejoras de regeneración
		Global.regeneracion_mejorada += 1  # Incrementa la tasa de regeneración
		guardar_mejoras()  # Guarda las mejoras
		actualizar_oro_label()  # Actualizar la etiqueta de oro
		actualizar_regeneracion_label()  # Actualiza el label de regeneración
	else:
		if Global.regeneracion_mejorada >= 5:
			print("Has alcanzado el máximo de mejoras de regeneración.")
		else:
			print("No tienes suficiente oro para mejorar la regeneración.")

func _on_Armadura_MejorarButton_pressed():
	var costo = 300  # Definir el costo de la mejora de armadura
	if Global.oro_disponible >= costo and Global.armadura_mejorada < 4:  # Limitar a 4 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		armadura_mejorada += 1  # Aumentar las mejoras de armadura
		Global.armadura_mejorada += 1  # Incrementa la armadura
		guardar_mejoras()  # Guarda las mejoras
		actualizar_oro_label()  # Actualizar la etiqueta de oro
		actualizar_armadura_label()  # Actualiza el label de armadura
	else:
		if Global.armadura_mejorada >= 4:
			print("Has alcanzado el máximo de mejoras de armadura.")
		else:
			print("No tienes suficiente oro para mejorar la armadura.")

func _on_Scroll_MejorarButton_pressed():
	var costo = 150  # Definir el costo de la mejora de enfriamiento de hechizo
	if Global.oro_disponible >= costo and Global.enfriamiento_hechizo_mejorado < 4:  # Limitar a 4 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		enfriamiento_hechizo_mejorado += 1  # Aumentar las mejoras de enfriamiento de hechizo
		Global.enfriamiento_hechizo_mejorado -= 1  # Reduce el tiempo de enfriamiento del hechizo
		guardar_mejoras()  # Guarda las mejoras
		actualizar_oro_label()  # Actualizar la etiqueta de oro
		actualizar_enfriamiento_hechizo_label()  # Actualiza el label del enfriamiento
	else:
		if Global.enfriamiento_hechizo_mejorado >= 4:
			print("Has alcanzado el máximo de mejoras de enfriamiento de hechizo.")
		else:
			print("No tienes suficiente oro para mejorar el enfriamiento de hechizo.")

func _on_Ring_MejorarButton_pressed():
	var costo = 250  # Definir el costo de la mejora de ataques adicionales
	if Global.oro_disponible >= costo and Global.ataques_adicionales_mejorado < 1:  # Limitar a 2 mejoras
		Global.oro_disponible -= costo
		save_gold()  # Guarda el oro después de la compra
		ataques_adicionales_mejorado += 1  # Aumentar las mejoras de ataques adicionales
		Global.ataques_adicionales_mejorado += 1  # Incrementa los ataques adicionales
		guardar_mejoras()  # Guarda las mejoras
		actualizar_oro_label()  # Actualizar la etiqueta de oro
		actualizar_ataques_adicionales_label()  # Actualiza el label de ataques adicionales
	else:
		if Global.ataques_adicionales_mejorado >= 1:
			print("Has alcanzado el máximo de mejoras de ataques adicionales.")
		else:
			print("No tienes suficiente oro para mejorar los ataques adicionales.")
		
# Actualiza el label de regeneración
func actualizar_regeneracion_label():
	regeneracion_label.text = "Regeneración: " + str(Global.regeneracion_mejorada) + " / 5"

# Actualiza el label de armadura
func actualizar_armadura_label():
	armadura_label.text = "Armadura: " + str(Global.armadura_mejorada) + " / 4"

# Actualiza el label de enfriamiento de hechizo
func actualizar_enfriamiento_hechizo_label():
	enfriamiento_hechizo_label.text = "Enfriamiento: " + str(Global.enfriamiento_hechizo_mejorado) + " / 4"

# Actualiza el label de ataques adicionales
func actualizar_ataques_adicionales_label():
	ataques_adicionales_label.text = "Ataques Adicionales: " + str(Global.ataques_adicionales_mejorado) + " / 2"
											
# Actualiza el label de velocidad
func actualizar_velocidad_label():
	velocidad_label.text = "Velocidad: " + str(Global.velocidad_mejorada) + " / 5"

# Actualiza el label de salud máxima
func actualizar_salud_label():
	salud_label.text = "Salud Máxima: " + str(Global.salud_maxima_mejorada) + " / 5"
	
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
		Global.regeneracion_mejorada = data.get("regeneracion_mejorada", 0)
		Global.armadura_mejorada = data.get("armadura_mejorada", 0)
		Global.enfriamiento_hechizo_mejorado = data.get("enfriamiento_hechizo_mejorado", 0)
		Global.ataques_adicionales_mejorado = data.get("ataques_adicionales_mejorado", 0)
		file.close()
	else:
		print("Archivo de mejoras no encontrado, inicializando valores por defecto.")
		Global.velocidad_mejorada = 0
		Global.salud_maxima_mejorada = 0
		Global.regeneracion_mejorada = 0
		Global.armadura_mejorada = 0
		Global.enfriamiento_hechizo_mejorado = 0
		Global.ataques_adicionales_mejorado = 0

# Función para guardar las mejoras seleccionadas antes de la partida
func guardar_mejoras():
	var file = FileAccess.open("user://mejoras_save.dat", FileAccess.WRITE)
	var data = {
		"velocidad_mejorada": Global.velocidad_mejorada,  # Usar Global
		"salud_maxima_mejorada": Global.salud_maxima_mejorada,  # Usar Global
		"regeneracion_mejorada": Global.regeneracion_mejorada,
		"armadura_mejorada": Global.armadura_mejorada,
		"enfriamiento_hechizo_mejorado": Global.enfriamiento_hechizo_mejorado,
		"ataques_adicionales_mejorado": Global.ataques_adicionales_mejorado,
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
