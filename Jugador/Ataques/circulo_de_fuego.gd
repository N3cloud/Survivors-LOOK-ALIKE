extends Area2D

var level = 1
var hp = 9999
var damage = 1
var speed = 100
var knockback_amount = 100
var attack_size = 1.0
var attack_speed = 20
var angle = Vector2.RIGHT
var rotation_speed = 2.0  # Velocidad de rotación
var attack_timer = 0.0  # Temporizador para controlar el ataque
var attack_delay = 1.0  # Tiempo entre ataques en segundos

@onready var player = get_tree().get_first_node_in_group("jugador")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var timer = $Timer
@onready var anim = $Sprite2D/AnimatedSprite2D

signal remove_from_array(object)

func _ready() -> void:
	timer.start()
	update_circulofuego()

func update_circulofuego():
	match level:
		1:
			hp = 9999
			damage = 1
			knockback_amount = 50
			attack_size = 1.0 * (1 + player.spell_size)
			rotation_speed = 2.0  # Velocidad de rotación
		2:
			hp = 9999
			damage = 2
			knockback_amount = 60
			attack_size = 1.0 * (1 + player.spell_size)
			rotation_speed = 2.0  # Velocidad de rotación
		3:
			hp = 9999
			damage = 3
			knockback_amount = 70
			attack_size = 1.0 * (1 + player.spell_size)
			rotation_speed = 2.0  # Velocidad de rotación
		4:
			hp = 9999
			damage = 5
			knockback_amount = 80
			attack_size = 1.0 * (1 + player.spell_size)
			rotation_speed = 3.0  # Velocidad de rotación
			
func _physics_process(delta: float) -> void:
	# Rotar alrededor del jugador
	angle = angle.rotated(rotation_speed * delta)  # Rotar el vector de dirección
	anim.play("default")  
	var radius = 50  # Radio del círculo de fuego
	global_position = player.global_position + angle * radius  # Actualiza la posición en base al ángulo
	
	# Verificar colisiones con enemigos en el grupo "enemigos"
	attack_timer += delta  # Incrementar el aaaaaaaaaaaatemporizador de ataque
	for enemy in get_tree().get_nodes_in_group("enemigos"):
		if global_position.distance_to(enemy.global_position) <= (attack_size * radius) and attack_timer >= attack_delay:
			var direction = (enemy.global_position - player.global_position).normalized()
			enemy.knockback = direction * knockback_amount
			enemy._on_hurt_box_hurt(damage, direction, knockback_amount)

			# Reiniciar el temporizador de ataque
			attack_timer = 0.0

func _on_body_entered(body: Node2D) -> void:
	pass
