extends CharacterBody2D


var movement_speed = 50.0
var hp = 80
var maxhp = 80
var last_movement = Vector2.UP

var experience = 0
var experience_level = 1
var collected_experience = 0

var health_regeneration_rate = 0  # Regeneración de salud por segundo
var regeneration_timer = 0.0  # Temporizador para la regeneración


#Ataques
var flecha = preload("res://Jugador/Ataques/flecha.tscn")
var arma2 = preload("res://Jugador/Ataques/arma_2.tscn")
var circulofuego = preload("res://Jugador/Ataques/circulo_de_fuego.tscn")
var pajarorayo = preload("res://Jugador/Ataques/pajarorayo.tscn")
var latigoviento = preload("res://Jugador/Ataques/latigo_de_viento.tscn")

#Ataque Nodos
@onready var flechaTimer = get_node("%flechaTimer")
@onready var flechaAttackTimer = get_node("%flechaAttackTimer")
@onready var arma2Timer = get_node("%arma2Timer")
@onready var arma2AtaqueTimer = get_node("%armar2AtaqueTimer")
@onready var circuloFuegoBase = get_node("%circuloFuegoBase")
@onready var pajarorayoTimer = get_node("%pajarorayoTimer")
@onready var pajarorayoAtaqueTimer = get_node("%pajarorayoAtaqueTimer")
@onready var latigovientoTimer = get_node("%latigovientoTimer")
@onready var latigovientoAtaqueTimer = get_node("%latigovientoAttackTimer")


#UPGRADES
var collected_upgrades = []
var upgrade_options = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var aditional_attacks = 0

var max_weapons = 5
var max_items = 5
var current_weapon_count = 0
var current_item_count = 0

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

#Circulo de fuego
var circulofuego_ammo = 0
var circulofuego_level = 0

#Pajaro de rayo
var pajarorayo_ammo = 0
var pajarorayo_base_ammo = 0
var pajarorayo_level = 0
var pajarorayo_attack_speed = 5

var returning = false
var return_speed = 200  

#Latigo de viento
var latigoviento_ammo = 0
var latigoviento_base_ammo = 0
var latigoviento_level = 0
var latigoviento_attack_speed = 2

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
@onready var death_panel = get_node("%DeathPanel")
@onready var label_result = get_node("%label_result")
@onready var sound_victory = get_node("%sound_victory")
@onready var sound_death = get_node("%sound_death")

#Signals
signal player_death

func _ready() -> void:
	upgrade_character("flecha1")
	attack()
	set_expbar(experience, calculated_experiencecap())
	_on_hurt_box_hurt(0,0,0) 

func _physics_process(delta: float) -> void:
	movement()
	regenerate_health(delta)
	
func regenerate_health(delta: float) -> void:
	if hp < maxhp:
		regeneration_timer += delta
		if regeneration_timer >= 1.0:  # Cada segundo
			hp += health_regeneration_rate
			hp = clamp(hp, 0, maxhp)  # Asegúrate de que no supere el máximo
			healthBar.value = hp  # Actualiza la barra de salud
			regeneration_timer = 0.0  # Reinicia el temporizador
			print(hp)
			
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
	if circulofuego_level > 0:
		spawn_circulofuego()
	if pajarorayo_level > 0:
		pajarorayoTimer.wait_time = pajarorayo_attack_speed * (1-spell_cooldown)
		if pajarorayoTimer.is_stopped():
			pajarorayoTimer.start()
	if latigoviento_level > 0:
		latigovientoTimer.wait_time = latigoviento_attack_speed * (1-spell_cooldown)
		if latigovientoTimer.is_stopped():
			latigovientoTimer.start()
				
func _on_hurt_box_hurt(damage: Variant, _angle, _knockback) -> void:
	hp -= clamp(damage - armor, 1.0,999.0) 
	healthBar.max_value = maxhp
	healthBar.value = hp
	if hp <= 0:
		death()
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

func spawn_circulofuego():
	var get_circulofuego_total = circuloFuegoBase.get_child_count()
	var calculate_spawns = (circulofuego_ammo + aditional_attacks) - get_circulofuego_total
	while calculate_spawns > 0:
		var circulofuego_spawn = circulofuego.instantiate()
		circulofuego_spawn.global_position = global_position
		circuloFuegoBase.add_child(circulofuego_spawn)
		calculate_spawns -= 1
	#Mejorar
	var get_circulofuego = circuloFuegoBase.get_children()
	for i in get_circulofuego:
		if i.has_method("update_circulofuego"):
			i.update_circulofuego()

func _on_pajarorayo_timer_timeout() -> void:
	pajarorayo_ammo += pajarorayo_base_ammo + aditional_attacks
	pajarorayoAtaqueTimer.start()

func _on_pajarorayo_ataque_timer_timeout() -> void:
	if pajarorayo_ammo > 0:
		var pajaro_attack = pajarorayo.instantiate()
		var target_enemy = get_nearby_enemy()
		pajaro_attack.position = get_tree().get_first_node_in_group("jugador").global_position  
		if target_enemy:  # Asegúrate de que hay un enemigo para atacar
			# Posiciona el pájaro cerca del enemigo
			pajaro_attack.target = target_enemy.global_position  # Establece el objetivo al enemigo
			pajaro_attack.start_move_to_enemy()
			add_child(pajaro_attack)
			
			pajarorayo_ammo -= 1
			if pajarorayo_ammo > 0:
				pajarorayoAtaqueTimer.start()
			else:
				pajarorayoAtaqueTimer.stop()
				
func _on_latigoviento_timer_timeout() -> void:
	latigoviento_ammo += latigoviento_base_ammo 
	latigovientoAtaqueTimer.start()


func _on_latigoviento_attack_timer_timeout() -> void:
	if latigoviento_ammo > 0:
		var latigo_attack = latigoviento.instantiate()
		latigo_attack.direction = Vector2.RIGHT  # Primer nivel ataca hacia la derecha
		latigo_attack.global_position = get_tree().get_first_node_in_group("jugador").global_position 
		add_child(latigo_attack)
		
		# Si hay ataques adicionales, añadir ataque hacia la izquierda
		if latigoviento_level == 2:
			var latigo_attack_left = latigoviento.instantiate()
			latigo_attack_left.direction = Vector2.LEFT  # Ataque adicional hacia la izquierda
			latigo_attack_left.global_position = get_tree().get_first_node_in_group("jugador").global_position 
			add_child(latigo_attack_left)
			
		
		latigoviento_ammo -= 1
		if latigoviento_ammo > 0:
			latigovientoAtaqueTimer.start()
		else:
			latigovientoAtaqueTimer.stop()
	
func get_enemy_above_position():
	var closest_enemy = get_random_target()  # Utiliza tu función existente para obtener un enemigo aleatorio
	
	if closest_enemy:  # Asegúrate de que hay un enemigo para atacar
		return closest_enemy.global_position + Vector2(0, -50)  # Ajusta el valor para determinar la altura
	return Vector2.ZERO  # Valor predeterminado si no hay enemigos

func get_nearby_enemy():
	if enemy_close.size() > 0:
		# Selecciona un enemigo aleatorio de la lista
		var random_index = randi() % enemy_close.size()
		return enemy_close[random_index]
	return null  # Devuelve null si no hay enemigos cerca
	
func get_random_target():
	var closest_enemy = null
	var closest_distance = INF  # Usamos un valor infinito para iniciar

	for enemy in enemy_close:  # Asumiendo que enemy_close es un array de enemigos
		var distance = global_position.distance_to(enemy.global_position)
		
		# Comparamos la distancia del enemigo actual con la más cercana
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	# Si encontramos un enemigo más cercano, devolvemos su posición, de lo contrario, devolvemos un valor predeterminado
	if closest_enemy:
		return closest_enemy.global_position
	else:
		return Vector2.UP  # O cualquier valor predeterminado que desees


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
	# Obtener el tamaño de la pantalla y del levelPanel
	var screen_size = get_viewport_rect().size
	var panel_size = levelPanel.get_rect().size  

	# Calcular la posición centrada
	var centered_position = Vector2(
		(screen_size.x - panel_size.x) / 2,  # Centrar horizontalmente
		(screen_size.y - panel_size.y) / 2   # Centrar verticalmente
	)

	# Crear el tween para mover el levelPanel al centro
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", centered_position, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
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
			if flecha_level == 0:  # Si es una nueva arma
				current_weapon_count += 1
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
			if arma2_level == 0:  # Si es una nueva arma
				current_weapon_count += 1
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
		"fuego1":
			if circulofuego_level == 0:  # Si es una nueva arma
				current_weapon_count += 1
			circulofuego_level = 1
			circulofuego_ammo += 1
		"fuego2":
			circulofuego_level = 2
			circulofuego_ammo += 2
		"fuego3":
			circulofuego_level = 3
			circulofuego_ammo += 3
		"fuego4":
			circulofuego_level = 4
			circulofuego_ammo += 4
		"rayo1":
			if pajarorayo_level == 0:  # Si es una nueva arma
				current_weapon_count += 1
			pajarorayo_level = 1
			pajarorayo_base_ammo += 1
		"rayo2":
			pajarorayo_level = 2
			pajarorayo_base_ammo += 2
		"rayo3":
			pajarorayo_level = 3
			pajarorayo_base_ammo += 3
		"rayo4":
			pajarorayo_level = 4
			pajarorayo_base_ammo += 4
		"viento1":
			if latigoviento_level == 0:  # Si es una nueva arma
				current_weapon_count += 1
			latigoviento_level = 1
			latigoviento_base_ammo += 1
		"viento2":
			latigoviento_level = 2
			latigoviento_base_ammo += 1
		"regeneracion1","regeneracion2","regeneracion3","regeneracion4","regeneracion5":
			if health_regeneration_rate == 0:  # Si es un nuevo ítem
				current_item_count += 1
			health_regeneration_rate += 0.5  # Ajusta la cantidad de regeneración
		"armor1","armor2","armor3","armor4":
			if armor == 0:  # Si es un nuevo ítem
				current_item_count += 1
			armor += 1
		"speed1","speed2","speed3","speed4":
			if movement_speed == speed:  # Considera como nuevo ítem si es la base
				current_item_count += 1
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			if spell_size == 0:  # Considera como nuevo ítem si es la base
				current_item_count += 1
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			if spell_cooldown == 0:  # Considera como nuevo ítem si es la base
				current_item_count += 1
			spell_cooldown += 0.05
		"ring1","ring2":
			if aditional_attacks == 0:  # Considera como nuevo ítem si es la base
				current_item_count += 1
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
		elif UpgradeDb.UPGRADES[i]["type"] == "item" and current_item_count >= max_items:
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "weapon" and current_weapon_count >= max_weapons:
			pass  # Ya tiene el número máximo de armas
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
					
func death():
	death_panel.visible = true
	emit_signal("player_death")
	get_tree().paused = true
	
	# Obtener el tamaño de la pantalla y del death_panel
	var screen_size = get_viewport_rect().size
	var panel_size = death_panel.get_rect().size  # Obtener el tamaño del death_panel

	# Calcular la posición centrada
	var centered_position = Vector2(
		(screen_size.x - panel_size.x) / 2,  # Centrar horizontalmente
		(screen_size.y - panel_size.y) / 2   # Centrar verticalmente
	)
	# Crear el tween para mover el death_panel al centro
	var tween = death_panel.create_tween()
	tween.tween_property(death_panel, "position", centered_position, 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	if hp <= 0:
		label_result.text = "GAME OVER"
		sound_death.play()


func _on_button_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://titleScreen/menu.tscn")
