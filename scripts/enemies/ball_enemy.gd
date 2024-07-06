extends BaseEnemy

var is_noticed: bool = false
var noticed_body: Node2D

func move(delta):
	if is_noticed and not is_on_floor():
		velocity.y += gravity * delta


func _on_notice_area_entered(body: Node2D):
	noticed_body = body
	is_noticed = true


func _on_attack_area_entered(body):
	pass # Replace with function body.
