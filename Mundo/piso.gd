extends TileMapLayer

@onready var player = get_tree().get_first_node_in_group("jugador")

# Multiplicador para ajustar la velocidad del desplazamiento
var parallax_factor = Vector2(0.5, 0.5)

func _process(delta):
	if player:
		# Actualiza la posición del TileMap para que siga al jugador
		global_position = player.global_position * parallax_factor
