extends Control

var level_select_menu: PackedScene = load("res://scenes/menus/level_select.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.fade_in(self, 100)

func change_menu(scene: PackedScene):
	Global.play_btn_sound()
	await Global.fade_out(self)
	get_tree().change_scene_to_packed(scene)

func _on_play_btn_pressed():
	change_menu(level_select_menu)


func _on_quit_btn_pressed():
	get_tree().quit()
