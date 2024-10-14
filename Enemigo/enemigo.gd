extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("jugador")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var sound_hit = $sound_hit
@onready var hitbox = $HitBox
@onready var damage_label = $Label
@onready var hideTimer = $HideTimer
@onready var collision = $CollisionShape2D


#Optimizacion
var screen_size 

var death_anim = preload("res://Enemigo/enemigo_1_muerte.tscn")
var exp = preload("res://Objetos/experiencia.tscn")

signal remove_from_array(object)

func _ready() -> void:
	anim.play("walk")
	hitbox.damage = enemy_damage
	screen_size =  get_viewport_rect().size
	hideTimer.connect("timeout",Callable(self,"_on_hide_timer_timeout"))

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(	Vector2.ZERO, knockback_recovery)
	var direction = (player.global_position - (global_position - Vector2(0, 0))).normalized()
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < 0.1:
		sprite.flip_h = false

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale 
	enemy_death.global_position =  global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_exp = exp.instantiate()
	new_exp.global_position = global_position
	new_exp.experience = experience
	loot_base.call_deferred("add_child", new_exp)
	queue_free()

func _on_hurt_box_hurt(damage: Variant, angle: Variant, knockback_amount: Variant ) -> void:
	hp -= damage 
	print("Damage received: ", damage)
	knockback = angle * knockback_amount
	
	

	
	if hp <= 0:
		death()
	else:
		sound_hit.play()		# Mostrar daño
		var damage_label = $Label  # Asegúrate de que esta ruta sea correcta
		damage_label.text = str(damage)
		damage_label.show()
		damage_label.scale = Vector2(0.5, 0.5)  # Asegúrate de que el tamaño sea el correcto
		damage_label.modulate = Color(1, 1, 1)  # Blanco
		await get_tree().create_timer(0.5).timeout  # Espera un segundo
		damage_label.hide()  # Oculta el texto después de mostrarlo

func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision.call_deferred("set","disabled",true)
		anim.stop()

func _on_hide_timer_timeout() -> void:
	var location_dif  = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x/2) * 1.4 || abs(location_dif.y) > (screen_size.y/2) * 1.4:
		visible = false
		anim.stop()  # Detener animaciones
		collision.disabled = true  # Desactivar colisiones
	else:
		visible = true
		anim.play("walk")  # Reanudar animaciones
		collision.disabled = false  # Activar colisiones
