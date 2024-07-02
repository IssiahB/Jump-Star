extends CharacterBody2D

class_name Player

signal player_won
signal player_lost
signal taken_damage
signal collect_item(item)

# Constant Properties
const WALK_SPEED = 150.0
const SPRINT_SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Player Properties
var health = 100

# Movement Properties
var speed: float = 0.0
var direction: float = 0.0
var acceleration: float = 10.0
var friction: float = 40.0
var portal_position: Vector2

# Player Conditions
var is_jumping: bool = false
var is_sprinting: bool = false
var entering_portal: bool = false
var is_facing_right: bool = true
@onready var sprite: AnimatedSprite2D = $PlayerSprite

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$JumpSound.volume_db = Global.volume

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()
	
	if health <= 0:
		queue_free()
	
func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false
		
	if entering_portal:
		handle_portal_movement()
	else:
		jump()
		axis_movement()
		sprint_movement()
		movement_animations()
	
func jump():
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		$JumpSound.play()
		is_jumping = true
		velocity.y = JUMP_VELOCITY
		
func axis_movement():
	direction = Input.get_axis("left", "right")
	if direction:
		# Prevent sliding when changing direction
		if sign(velocity.x) != sign(direction) and velocity.x != 0: # if change direction
			velocity.x = move_toward(velocity.x, 0, friction) # slow down
		else:
			# Speed up
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		# Not moving slow down
		velocity.x = move_toward(velocity.x, 0, friction)
	
func sprint_movement():
	if not is_on_floor():
		return
	
	if Input.is_action_pressed("sprint") and is_on_floor():
		is_sprinting = true
		speed = SPRINT_SPEED
	else:
		is_sprinting = false
		speed = WALK_SPEED
	
func movement_animations():
	# Facing
	if direction < 0 and is_facing_right:
		scale.x = -scale.x
		is_facing_right = false
	elif direction > 0 and not is_facing_right:
		scale.x = -scale.x
		is_facing_right = true
	
	# Jumping
	if is_jumping:
		sprite.play("jump")
		return
	# Idle
	if direction == 0:
		sprite.play("idle")
	
	# Walking/Sprinting
	if direction != 0 and not is_sprinting:
		sprite.play("walk")
	elif direction != 0 and is_sprinting:
		sprite.play("sprint")
		
func handle_portal_movement():
	direction = (portal_position - global_position).normalized().x
	
	# Animation/Movement
	if global_position.distance_to(portal_position) > 1:
		if is_on_floor():
			$PlayerSprite.play("walk")
			velocity.x = direction * 20
	else:
		$PlayerSprite.play("idle")
		$PlayerSprite.pause()
		velocity.x = 0
		
	# Facing
	if direction < 0 and is_facing_right:
		scale.x = -scale.x
		is_facing_right = false
	elif direction > 0 and not is_facing_right:
		scale.x = -scale.x
		is_facing_right = true
	
	# Fade out
	if not $PlayerSprite.is_playing():
		player_won.emit()
	

func enter_portal(portal_pos):
	entering_portal = true
	portal_position = portal_pos

func take_damage(amount: int):
	health -= amount
	taken_damage.emit()
	
func pickup_item(item):
	collect_item.emit(item)

func _exit_tree():
	if not entering_portal:
		player_lost.emit()
