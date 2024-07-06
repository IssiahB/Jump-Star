extends Node2D

signal interaction_requested(body)

## The area in which this component checks for entering bodies
@export var interaction_area: Area2D
## The dialog that will be shown or hidden based off if a body is inside the
## interaction area
@export var interaction_dialog: Sprite2D

## The body that is being interacted with
var interact_body: Node2D
var body_inside: bool = false

var is_off: bool = false

func _ready():
	if not interaction_area:
		printerr("Requires Area2D")
		is_off = true
	
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
func _input(event):
	if is_off:
		return
	
	if Input.is_action_just_pressed("interact") and body_inside:
		interaction_requested.emit(interact_body)
		
func turn_off():
	interaction_dialog.hide()
	is_off = true
	
func _on_body_entered(body: Node2D):
	if is_off:
		return
		
	if interaction_dialog:
		interaction_dialog.show()
	interact_body = body
	body_inside = true
	
func _on_body_exited(body: Node2D):
	if is_off:
		return
	
	if interaction_dialog:
		interaction_dialog.hide()
	body_inside = false
