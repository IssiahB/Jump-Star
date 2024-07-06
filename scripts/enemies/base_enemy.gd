extends CharacterBody2D

class_name BaseEnemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# The maximum amount of health this enemy can have
@export var max_health: int = 100

# Movemnt properties
@export_group("Movement")
var speed: float = 0.0
# The maximum speed this enemy is allowed to go
@export var max_speed: int = 100
@export var acceleration: float = 5
@export var deceleration: float = 10

@export_group("Player Interaction")
@export var damage_amount: int = 25


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	move(delta)
	
	clamp(speed, 0.0, max_speed)
	move_and_slide()

func move(delta):
	pass
	
func take_damage(damage_amount: int):
	pass
