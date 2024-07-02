extends Area2D

class_name Coin

var picked_up: bool = false

func _ready():
	$CoinSound.volume_db = Global.volume

func _on_body_entered(body):
	if picked_up:
		return
	
	hide()
	picked_up = true
	body.pickup_item(self)
	$CoinSound.play()
	await $CoinSound.finished
	
	queue_free()
