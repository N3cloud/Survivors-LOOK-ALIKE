extends ColorRect

@onready var label_name = $label_nombre
@onready var label_description = $label_descripcion
@onready var label_level = $label_nivel
@onready var itemIcon = $ColorRect/ItemIcon

var item = null
@onready var jugador = get_tree().get_first_node_in_group("jugador") 
@onready var button = $TextureButton

signal selected_upgrade(upgrade)

func _ready() -> void:
	connect("selected_upgrade",Callable(jugador, "upgrade_character"))
	if item == null:
		item = "comida"
	label_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	label_description.text = UpgradeDb.UPGRADES[item]["details"]
	label_level.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	assert(button.pressed.connect(_on_button_pressed) == OK)

func _on_button_pressed() -> void:
	print("Se ha presionado el botón")
	emit_signal("selected_upgrade", item)
	print("Se ha emitido la señal selected_upgrade")
