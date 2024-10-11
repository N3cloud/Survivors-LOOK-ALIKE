extends Area2D

var level = 1

var hp = 1
var damage = 5
var speed = 100
var knockback_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

var shake_amplitude = 0.5  # Amplitud del temblor
var shake_speed = 80.0       # Velocidad del temblor
var shake_time = 0.0        # Tiempo para el temblor

@onready var player = get_tree().get_first_node_in_group("jugador")

signal remove_from_array(object)

func _ready() -> void:
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(0)
	match level:
		1:
			hp = 1
			speed = 120
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 120
			damage = 5
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 120
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 120
			damage = 8
			knockback_amount = 100
			attack_size = 1.0 * (1 + player.spell_size)		
			
func _physics_process(delta: float) -> void:
	shake_time += delta * shake_speed
	var shake_offset = sin(shake_time) * shake_amplitude  # Calcula el desplazamiento lateral
	position += angle * speed * delta  # Mueve la flecha hacia adelante
	position.x += shake_offset  # Aplica el temblor lateral

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
	


func _on_timer_timeout() -> void:
	emit_signal("remove_from_array", self)
	queue_free()
