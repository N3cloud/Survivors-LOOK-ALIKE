extends Node

var oro_disponible = 0 
var velocidad_mejorada = 0
var salud_maxima_mejorada = 0

func guardar_mejoras(velocidad, salud):
	velocidad_mejorada = velocidad
	salud_maxima_mejorada = salud
	print("Mejoras guardadas: Velocidad =", velocidad_mejorada, " Salud Máxima =", salud_maxima_mejorada)

func load_gold():
	var file = FileAccess.open("user://gold_save.dat", FileAccess.READ)
	if file:
		oro_disponible = file.get_var()  # Cargar la cantidad de oro
		file.close()
	else:
		oro_disponible = 0  # Si no existe el archivo, inicializa con 0 oro

func save_gold():
	var file = FileAccess.open("user://gold_save.dat", FileAccess.WRITE)
	file.store_var(oro_disponible)  # Guarda el oro actual
	file.close()
	
