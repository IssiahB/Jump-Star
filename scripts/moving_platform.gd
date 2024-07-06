extends CharacterBody2D

@export var path: Path2D
@export var follow_speed: float = 100.0
@export var hold_position_time: float = 3.0

var path_follower: PathFollow2D

var can_move: bool = false
var timer_started: bool = false
var moving_forwards: bool = true

func _ready():
	$HoldPosTimer.wait_time = hold_position_time
	path_follower = PathFollow2D.new()
	path_follower.loop = false
	path_follower.rotates = false
	
	if path:
		path.add_child(path_follower)
		can_move = true
		global_position = path_follower.global_position
	else:
		printerr("Needs a path to follow")
		
func _physics_process(delta):
	if not can_move:
		return
		
	if moving_forwards:
		if path_follower.progress_ratio < 1:
			path_follower.progress += follow_speed * delta
		else:
			start_timer()
	else:
		if path_follower.progress_ratio > 0:
			path_follower.progress -= follow_speed * delta
		else:
			start_timer()
	
	move()
	move_and_slide()
	
func move():
	var move_dir = global_position.direction_to(path_follower.global_position)
	if not timer_started:
		velocity = move_dir * (follow_speed + 1)
	else:
		velocity = Vector2.ZERO

func start_timer():
	if not timer_started:
		timer_started = true
		$HoldPosTimer.start()

func _on_hold_pos_timer_timeout():
	moving_forwards = !moving_forwards
	timer_started = false
