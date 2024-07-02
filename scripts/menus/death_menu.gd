extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.fade_in(self)

func _on_retry_btn_pressed():
	if Global._current_world:
		Global.play_btn_sound()
		await Global.fade_out(self)
		get_tree().change_scene_to_packed(Global._current_world.world_scene)


func _on_main_menu_btn_pressed():
	Global.play_btn_sound()
	await Global.fade_out(self)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
