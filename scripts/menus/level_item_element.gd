extends Panel
class_name LevelElement

signal level_clicked(level_scene: PackedScene)

var level_scene: PackedScene
var level_title: StringName
var level_status_image: Texture

var is_mouse_inside: bool = false
var is_locked: bool = false

var starting_color_alpha: float

func _ready():
	starting_color_alpha = self_modulate.a
	$HBoxContainer/LevelTitle.text = level_title
	$HBoxContainer/StatusImg.texture = level_status_image

func _input(event: InputEvent):
	if is_locked:
		return
	
	if event.is_action_pressed("select") and is_mouse_inside:
		level_clicked.emit(level_scene)


func _on_mouse_entered():
	self_modulate.a = 0.1
	is_mouse_inside = true
	if is_locked:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN


func _on_mouse_exited():
	self_modulate.a = 1
	is_mouse_inside = false
