extends Area2D

var player_body: Player
# TODO glow with light and animate the intensity 

func _on_body_entered(body):
	player_body = body
	player_body.enter_portal(global_position)
