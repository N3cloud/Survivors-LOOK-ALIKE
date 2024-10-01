extends CharacterBody2D


var movement_speed = 50.0
var hp = 80
var last_movement = Vector2.UP

var experience = 0
var experience_level = 1
var collected_experience = 0

#Ataques
var flecha = preload("res://Jugador/Ataques/flecha.tscn")
var arma2 = preload("res://Jugador/Ataques/arma_2.tscn")

#Ataque Nodos
@onready var flechaTimer = get_node("%flechaTimer")
@onready var flechaAttackTimer = get_node("%flechaAttackTimer")
@onready var arma2Timer = get_node("%arma2Timer")
@onready var arma2AtaqueTimer = get_node("%armar2AtaqueTimer")

#Flecha
var flecha_ammo = 0
var flecha_base_ammo = 1
var flecha_attack_speed = 1.5
var flecha_level = 1

#Arma2
var arma2_ammo = 0
var arma2_base_ammo = 1
var arma2_attack_speed = 3
var arma2_level = 1

#Enemigos related

var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
@onready var anim = $Sprite2D/AnimatedSprite2D

#GUI
@onready var expBar = get_node("%ExpProgressBar")
@onready var label_level = get_node("%Label_Nivel")

func _ready() -> void:
	attack()
	set_expbar(experience, calculated_experiencecap())

func _physics_process(delta: float) -> void:
	movement();
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Input.get_vector("left", "right", "up", "down")
	if mov.x > 0:
		anim.flip_h = false
	elif mov.x < 0:
		anim.flip_h = true
	
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			anim.play("default")
			walkTimer.start()
		else :	
			walkTimer.start()
	else:
		if anim.get_animation() != "idle":
			anim.play("idle")
			
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if flecha_level > 0:
		flechaTimer.wait_time = flecha_attack_speed
		if flechaTimer.is_stopped():
			flechaTimer.start()
	if arma2_level > 0:
		arma2Timer.wait_time = arma2_attack_speed
		if arma2Timer.is_stopped():
			arma2Timer.start()
			
func _on_hurt_box_hurt(damage: Variant, _angle, _knockback) -> void:
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
		
func _on_arma_2_timer_timeout() -> void:
	arma2_ammo += arma2_base_ammo
	arma2AtaqueTimer.start()

func _on_armar_2_ataque_timer_timeout() -> void:
	if arma2_ammo > 0:
		var arma2_attack = arma2.instantiate()
		arma2_attack.position = position
		arma2_attack.last_movement = last_movement
		arma2_attack.level = arma2_level
		add_child(arma2_attack)
		arma2_ammo -= 1
		if arma2_ammo > 0:
			arma2AtaqueTimer.start()
		else:
			arma2AtaqueTimer.stop()
		
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


func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var exp = area.collect()
		calculate_experience(exp)
		
func calculate_experience(exp):
	var exp_required= calculated_experiencecap()
	collected_experience += exp
	if experience + collected_experience >= exp_required: #Subir de nivel
		collected_experience -= exp_required-experience
		experience_level += 1
		label_level.text = str("Nivel: ",experience_level)
		experience = 0
		exp_required = calculated_experiencecap()
		calculate_experience(0)
	else:
		experience += collected_experience 
		collected_experience = 0
	
	set_expbar(experience, exp_required)
	
	
func calculated_experiencecap():
	var exp_cap = experience_level	 
	if experience_level < 20:
		exp_cap = experience_level * 5
	elif experience_level <40:
		exp_cap + 90 * (experience_level-19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value
	
