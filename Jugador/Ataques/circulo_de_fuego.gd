extends Area2D

var level = 1
var hp = 9999
var damage = 5
var speed = 100
var knockback_amount = 100
var attack_size = 1.0
var angle = 0.0
var rotation_speed = 2.0  # Velocidad de rotación

@onready var player = get_tree().get_first_node_in_group("jugador")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer

signal remove_from_array(object)

func _ready() -> void:
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)

func _physics_process(delta: float) -> void:
	# Rotar alrededor del jugador
	angle += rotation_speed * delta  # Actualizar el ángulo
	var radius = 50  # Radio del círculo de fuego
	global_position = player.global_position + Vector2(cos(angle), sin(angle)) * radius

func enemy_hit(_charge):
	pass

func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
