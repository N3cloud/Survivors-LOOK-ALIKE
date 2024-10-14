extends ParallaxBackground

@onready var player = get_tree().get_first_node_in_group("jugador")

func _process(delta):
	if player:
		# Ajusta el scroll_offset del ParallaxBackground según la posición del jugador.
		scroll_offset = player.global_position * Vector2(0.5, 0.5)  # Puedes ajustar el multiplicador para la velocidad de desplazamiento.
