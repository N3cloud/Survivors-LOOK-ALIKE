extends Area2D

var level = 1
var damage = 10
var speed = 150
var knockback_amount = 100
var attack_size = 1.0
var direction = Vector2.RIGHT  # Por defecto hacia la derecha

@onready var player = get_tree().get_first_node_in_group("jugador")
@onready var anim = $Sprite2D/AnimatedSprite2D

signal remove_from_array(object)

func _ready() -> void:
	match level:
		1:
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			attack_size = 1.0 * (1 + player.spell_size)
			

func _physics_process(delta: float) -> void:
	anim.play("default")
	position += direction * speed * delta
	if direction == Vector2.LEFT:
		anim.flip_h = true  # Mantener la escala normal
	else:
		anim.flip_h = false  # Mantener la escala normal

	await get_tree().create_timer(0.75).timeout
	queue_free()

func enemy_hit(_charge):
	pass
