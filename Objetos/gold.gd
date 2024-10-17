extends Area2D

@export var gold = 1

var target = null
var speed = 0
var MAX_SPEED = 30.0

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready() -> void:
	self.add_to_group("gold")
		
func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)	
		speed = min(speed + 2 * delta, MAX_SPEED)
		
func collect():
	collision.call_deferred("set","disabled",true )
	sprite.visible = false
	return gold
