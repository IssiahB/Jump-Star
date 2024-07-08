extends CharacterBody2D

class_name Coin

var picked_up: bool = false
var can_pickup: bool = true

var moving: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$CoinSound.volume_db = Global.volume
	
func spawn():
	can_pickup = false
	moving = true
	randomize()
	var jump_height = randf_range(-300, -500)
	var jump_dir = randf_range(-50, 50)
	velocity.y = jump_height
	velocity.x = jump_dir
	$SpawnTimer.start()
	
func _process(delta):
	if not moving:
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# apply horizontal friction
	if velocity.x != 0:
		velocity.x += -sign(velocity.x)
		
	move_and_slide()

func _on_body_entered(body):
	if picked_up or not can_pickup:
		return
	
	hide()
	picked_up = true
	body.pickup_item(self)
	$CoinSound.play()
	await $CoinSound.finished
	
	queue_free()


func _on_spawn_timer_timeout():
	can_pickup = true
