extends Control

var is_dragging = false
var joystick_position = Vector2.ZERO
var joystick_radius = 100.0 # Ajusta según tu diseño

@onready var joystick_bg = $JoystickBackground # Cambia al nombre de tu sprite de fondo
@onready var joystick_handle = $JoystickHandle # Cambia al nombre de tu sprite del mango

func _ready():
	joystick_bg.position = position
	joystick_handle.position = position

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			joystick_position = event.position
			joystick_bg.position = joystick_position
			joystick_handle.position = joystick_position
		else:
			is_dragging = false
			joystick_bg.position = position
			joystick_handle.position = position

	elif event is InputEventScreenDrag and is_dragging:
		joystick_position = event.position
		var offset = joystick_position - position
		if offset.length() > joystick_radius:
			offset = offset.normalized() * joystick_radius
		joystick_handle.position = position + offset

func get_movement_vector():
	var offset = joystick_handle.position - position
	return offset.normalized()
