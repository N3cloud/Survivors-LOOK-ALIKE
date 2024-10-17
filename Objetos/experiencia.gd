extends Area2D

@export var experience = 1

var spr_green = preload("res://Textures/Items/Gems/sprite (3).png")
var spr_blue = preload("res://Textures/Items/Gems/sprite (3).png")
var spr_red = preload("res://Textures/Items/Gems/sprite (3).png")

var target = null
var speed = 0
var MAX_SPEED = 30.0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $sonido_exp

func _ready() -> void:
	self.add_to_group("experience")
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_green
	else:
		sprite.texture = spr_red
		
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)	
		speed = min(speed + 2 * delta, MAX_SPEED)
		
func collect():
	sound.play()	
	collision.call_deferred("set","disabled",true )
	sprite.visible = false
	return experience


func _on_sonido_exp_finished() -> void:
	queue_free()
