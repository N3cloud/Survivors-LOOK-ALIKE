extends ColorRect

var item = null
@onready var jugador = get_tree().get_first_node_in_group("jugador") 
@onready var button = $TextureButton

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade",Callable(jugador, "upgrade_character"))
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	assert(button.pressed.connect(_on_button_pressed) == OK)

func _on_button_pressed() -> void:
	print("Se ha presionado el botón")
	emit_signal("selected_upgrade", item)
	print("Se ha emitido la señal selected_upgrade")
