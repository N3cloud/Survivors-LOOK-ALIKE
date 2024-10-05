extends CharacterBody2D


var movement_speed = 50.0
var hp = 80
var maxhp = 80
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

#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var aditional_attacks = 0

#Flecha
var flecha_ammo = 0
var flecha_base_ammo = 0
var flecha_attack_speed = 1.5
var flecha_level = 0

#Arma2
var arma2_ammo = 0
var arma2_base_ammo = 0
var arma2_attack_speed = 3
var arma2_level = 0

#Enemigos related

var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%walkTimer")
@onready var anim = $Sprite2D/AnimatedSprite2D

#GUI
@onready var expBar = get_node("%ExpProgressBar")
@onready var label_level = get_node("%Label_Nivel")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var itemOption = preload("res://Utilidades/item_option.tscn")
@onready var sound_levelUp = get_node("%sound_levelUp")
@onready var healthBar = get_node("%HpBar")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Jugador/GUI/item_container.tscn")


func _ready() -> void:
	upgrade_character("flecha1")
	attack()
	set_expbar(experience, calculated_experiencecap())
	_on_hurt_box_hurt(0,0,0) 

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
		flechaTimer.wait_time = flecha_attack_speed * (1-spell_cooldown)
		if flechaTimer.is_stopped():
			flechaTimer.start()
	if arma2_level > 0:
		arma2Timer.wait_time = arma2_attack_speed * (1-spell_cooldown)
		if arma2Timer.is_stopped():
			arma2Timer.start()
			
func _on_hurt_box_hurt(damage: Variant, _angle, _knockback) -> void:
	hp -= clamp(damage - armor, 1.0,999.0) 
	healthBar.max_value = maxhp
	healthBar.value = hp
	print(hp)


func _on_flecha_timer_timeout() -> void:
	flecha_ammo += flecha_base_ammo + aditional_attacks
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
	arma2_ammo += arma2_base_ammo + aditional_attacks
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
		experience = 0
		exp_required = calculated_experiencecap()
		levelup()
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
	
func levelup():
	sound_levelUp.play()
	label_level.text = str("Nivel: ",experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel,"position", Vector2(220,50),0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var options_max = 3
	
	while options < options_max:
		var option_choice = itemOption.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"flecha1":
			flecha_level = 1
			flecha_base_ammo += 1
		"flecha2":
			flecha_level = 2
			flecha_base_ammo += 1
		"flecha3":
			flecha_level = 3
		"flecha4":
			flecha_level = 4
			flecha_base_ammo += 2
		"dark1":
			arma2_level = 1
			arma2_base_ammo += 1
		"dark2":
			arma2_level = 2
			arma2_base_ammo += 1
		"dark3":
			arma2_level = 3
			arma2_base_ammo -= 0.5
		"dark4":
			arma2_level = 4
			arma2_base_ammo += 1
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			aditional_attacks += 1
		"comida":
			hp += 20
			hp = clamp(hp,0,maxhp)
	
	adjust_gui_collection_upgrade(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(800,50)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades:
			pass
		elif i in upgrade_options:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item":
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0:
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add == true:	
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options.append(randomitem)
		return randomitem
	else:
		return null
				

func adjust_gui_collection_upgrade(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)
