extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health/VBoxContainer.tooltip_text = str(%HealthBar.value) + "%"
	$Coins/VBoxContainer.tooltip_text = %CoinCount.text + " Coins"
	
func update_health(health: int):
	%HealthBar.value = health

func update_coins(coins: int):
	%CoinCount.text = str(coins)
