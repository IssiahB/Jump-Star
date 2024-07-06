extends StaticBody2D
class_name Chest

var closed_region: Rect2 = Rect2(8, 10, 17, 19)
var open_region: Rect2 = Rect2(40, 10, 17, 19)

var coin_scene: PackedScene = preload("res://scenes/coin.tscn")

## Amount of coins contained in chest
@export var coin_contained: int = 5

func spawn_coins():
	for i in range(coin_contained):
		var coin = coin_scene.instantiate()
		add_child(coin)
		coin.spawn()

func _on_interaction(body):
	$ChestSprite.region_rect = open_region
	$InteractionComponent.turn_off()
	
	spawn_coins()
