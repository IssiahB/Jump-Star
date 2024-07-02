extends Control

var display_coins: int
var total_coins: int
var newly_collected_coins: int

var coins_finished_animted: bool = false

func _ready():
	Global.fade_in(self)
	remove_next_lvl_btn()
	total_coins = Global.player_properties.total_coins
	newly_collected_coins = Global.player_properties.new_coins
	display_coins = total_coins - newly_collected_coins
	
	animate_coins()

func animate_coins():
	var animate_tween = get_tree().create_tween()
	animate_tween.tween_property(self, "display_coins", total_coins, 1)
	animate_tween.set_ease(Tween.EASE_IN_OUT)
	animate_tween.play()
	
	await animate_tween.finished
	coins_finished_animted = true

func _process(delta):
	if not coins_finished_animted:
		update_coin_count()

func update_coin_count():
	%CoinCount.text = str(display_coins)

func remove_next_lvl_btn():
	if Global._next_world == null:
		$VBoxContainer/Buttons.remove_child(%NextLvlBtn)

func _on_next_lvl_btn_pressed():
	var new_world: World = Global.select_next_world()
	Global.play_btn_sound()
	await Global.fade_out(self)
	
	get_tree().change_scene_to_packed(new_world.world_scene)

func _on_main_menu_btn_pressed():
	Global.play_btn_sound()
	await Global.fade_out(self)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
