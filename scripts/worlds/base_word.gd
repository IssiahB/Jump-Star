extends Node2D

class_name BaseWorld

var collected_coins: int = 0
var death_menu: PackedScene = preload("res://scenes/menus/death_menu.tscn")
var victory_menu: PackedScene = preload("res://scenes/menus/victory_menu.tscn")
var main_menu: PackedScene = preload("res://scenes/menus/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.fade_in(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Player.taken_damage.connect(update_hub)
	$Player.collect_item.connect(handle_item_pickup)
	$Player.player_lost.connect(handle_death)
	$Player.player_won.connect(handle_win)
	update_hub()
	
func _input(event):
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$PauseMenu.show()
	
func handle_win():
	$HUD.hide()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await Global.fade_out(self)
	
	Global.player_properties.new_coins = collected_coins
	get_tree().change_scene_to_packed(victory_menu)

func handle_death():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$HUD.hide()
	await Global.fade_out(self)
	# TODO handle camera jumping
	
	get_tree().change_scene_to_packed(death_menu)

func update_hub():
	$HUD.update_health($Player.health)
	$HUD.update_coins(collected_coins)

func handle_item_pickup(item):
	if item is Coin:
		collected_coins += 1
		update_hub()

func _on_fall_zone_entered(body):
	body.queue_free()


func _on_pause_main_menu_pressed():
	$HUD.hide()
	$PauseMenu.hide()
	
	Global.play_btn_sound()
	await Global.fade_out(self)
	get_tree().change_scene_to_packed(main_menu)


func _on_pause_resume_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.play_btn_sound()
	$PauseMenu.hide()


func _on_pause_store_pressed():
	Global.play_btn_sound()
	pass # Replace with function body.
