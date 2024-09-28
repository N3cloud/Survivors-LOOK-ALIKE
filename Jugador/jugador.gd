extends CharacterBody2D


var movement_speed = 40.0
var hp = 80

#Ataques
var flecha = preload("res://Jugador/Ataques/flecha.tscn")

#Ataque Nodos
@onready var flechaTimer = get_node("%flechaTimer")
@onready var flechaAttackTimer = get_node("%flechaAttackTimer")

#Flecha
var flecha_ammo = 0
var flecha_base_ammo = 1
var flecha_attack_speed = 1.5
var flecha_level = 1

#Enemigos related

var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")

func _ready() -> void:
	attack()

func _physics_process(delta: float) -> void:
	movement();
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Input.get_vector("left", "right", "up", "down")
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
	
	if mov != Vector2.ZERO:
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else :
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if flecha_level > 0:
		flechaTimer.wait_time = flecha_attack_speed
		if flechaTimer.is_stopped():
			flechaTimer.start()

func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage 
	print(hp)


func _on_flecha_timer_timeout() -> void:
	flecha_ammo += flecha_base_ammo
	flechaAttackTimer.start()


func _on_flecha_attack_timer_timeout() -> void:
	if flecha_ammo > 0:
		var flecha_attack = flecha.instantiate()
		flecha_attack.position = position
		flecha_attack.target = get_random_target()
		flecha_attack.level = flecha_level
		add_child(flecha_attack)
		flecha_ammo -= 1
		if flecha_ammo > 0:
			flechaAttackTimer.start()
		else:
			flechaAttackTimer.stop()
		
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
