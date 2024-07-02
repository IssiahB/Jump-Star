extends Node
class_name PlayerProperties

var total_coins: int = 0
var new_coins: int = 0:
	set(value):
		total_coins += value
		new_coins = value
