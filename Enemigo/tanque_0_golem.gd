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

var death_anim = preload("res://Enemigo/tanque0golem_muerte.gd")
var exp = preload("res://Objetos/experiencia.tscn")

signal remove_from_array(object)

func _ready() -> void:
	anim.play("walk")
	hitbox.damage = enemy_damage

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(	Vector2.ZERO, knockback_recovery)
	var direction = (player.global_position - (global_position - Vector2(0, 0))).normalized()
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < 0.1:
		sprite.flip_h = true

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

		
		
		
