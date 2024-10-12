extends Area2D

var level = 1
var hp = 1
var damage = 5
var speed = 100
var knockback_amount = 100
var attack_size = 1.0
var target = Vector2.ZERO
var angle = Vector2.ZERO
var player_position = Vector2.ZERO
var moving_to_enemy = false
var returning = false

@onready var player = get_tree().get_first_node_in_group("jugador")
@onready var timer = $Timer  # Asegúrate de tener un Timer como hijo de este nodo
@onready var anim = $Sprite2D/AnimatedSprite2D

var death_anim = preload("res://Jugador/Ataques/pajarorayoimpacto.tscn")

signal remove_from_array(object)

func _ready() -> void:
	# Calcular la dirección hacia el objetivo
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(0)
	
	# Configuración de nivel
	match level:
		1:
			hp = 2
			speed = 100
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 3
			speed = 100
			damage = 10
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 4
			speed = 100
			damage = 15
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 5
			speed = 150
			damage = 20
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)        
			

func _physics_process(delta: float) -> void:
	# Mover el pájaro de rayo hacia la dirección del objetivo
	anim.play("default")
	if moving_to_enemy:
		# Movimiento hacia el enemigo
		var direction_to_enemy = (target - position).normalized()
		position += direction_to_enemy * speed * delta
		
		# Voltear la animación según la dirección
		if direction_to_enemy.x < 0:
			anim.flip_h = true  # Voltear el sprite
		else:
			anim.flip_h = false  # Voltear el sprite

		# Verifica si ha llegado al enemigo (o cerca de él)
		if position.distance_to(target) < 10:  # Ajusta este valor según sea necesario
			enemy_hit()  # Llama a la función de golpeo al enemigo
			moving_to_enemy = false  # Cambia el estado a no moviéndose al enemigo
			returning = true  # Inicia el regreso al jugador
	elif returning:
		# Regresa hacia el jugador
		player_position = player.global_position  # Obtiene la posición del jugador
		var direction_to_player = (player_position - position).normalized()
		position += direction_to_player * speed * delta  
		
		if direction_to_player.x < 0:
			anim.flip_h = true  # Voltear el sprite
		else:
			anim.flip_h = false  # Voltear el sprite

		# Verifica si el pájaro ha llegado a la posición del jugador
		if position.distance_to(player_position) < 10:  # Ajusta este valor según sea necesario
			queue_free()  # Destruye el pájaro cuando llegue al jugador

func start_move_to_enemy() -> void:
	moving_to_enemy = true

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		var enemy_death = death_anim.instantiate()
		enemy_death.scale = anim.scale 
		enemy_death.global_position =  global_position
		get_parent().call_deferred("add_child", enemy_death)
		queue_free()


func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
