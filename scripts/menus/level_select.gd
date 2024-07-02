extends Control

@export var locked_texture: Texture
@export var unlocked_texture: Texture

var main_menu: PackedScene = load("res://scenes/menus/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.fade_in(self, 100)
	var level_element_scene: PackedScene = load("res://scenes/menus/level_item_element.tscn")
	
	for world in Global.worlds:
		var level_element: LevelElement = level_element_scene.instantiate()
		level_element.level_title = world.name
		level_element.level_scene = world.world_scene
		
		if world.status == world.LockState.LOCKED:
			level_element.is_locked = true
			level_element.level_status_image = locked_texture
		else:
			level_element.is_locked = false
			level_element.level_status_image = unlocked_texture
		
		level_element.level_clicked.connect(change_scene)
		%Levels.add_child(level_element)

func change_scene(scene: PackedScene):
	Global.select_world(scene)
	Global.play_btn_sound()
	await Global.fade_out(self)
	get_tree().change_scene_to_packed(scene)

func _on_back_btn_pressed():
	change_scene(main_menu)
