extends BaseEnemy

var facing_right: bool = true
var direction: Vector2 = Vector2.ZERO

# Player Interaction Properties
var player_body: Player
var should_attack: bool = false
var should_deal_damage: bool = false
var player_noticed: bool = false

## The time in seconds between damage dealt to player
@export var attack_time: float = .8

func _ready():
	pass

func move(delta):
	# Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not should_attack:
		follow_player()
		look_in_direction()
	
	velocity.x = direction.x * speed
	
func _process(delta):
	play_animations()

func follow_player():
	if player_noticed and player_body:
		direction = (player_body.global_position - global_position).normalized()
		speed = move_toward(speed, max_speed, acceleration)
	else:
		speed = move_toward(speed, 0, deceleration)
		
func look_in_direction():
	if sign(direction).x < 0 and facing_right:
		scale.x = -scale.x
		facing_right = false
	elif sign(direction).x > 0 and not facing_right:
		scale.x = -scale.x
		facing_right = true
		
func play_animations():
	if speed and not should_attack:
		$BlobSprite.play("walk")
	elif not speed and not should_attack:
		$BlobSprite.play("idle")
	elif should_attack:
		$BlobSprite.play("attack")
		
	check_animation_looped()
		
	# Damage player at proper frame
	if $BlobSprite.animation == "attack" and $BlobSprite.frame == 3 and should_deal_damage:
		if player_body and "take_damage" in player_body:
			player_body.take_damage(damage_amount)
			should_deal_damage = false


func check_animation_looped():
	await $BlobSprite.animation_looped

	match $BlobSprite.animation:
		"attack":
			should_deal_damage = true
		"idle":
			pass
		"walk":
			pass
	

func _on_notice_zone_entered(body):
	player_noticed = true
	player_body = body

func _on_notice_zone_exited(_body):
	player_noticed = false

func _on_attack_zone_entered(body):
	should_deal_damage = true
	should_attack = true
	player_body = body

func _on_attack_zone_exited(_body):
	should_attack = false
	should_deal_damage = false
