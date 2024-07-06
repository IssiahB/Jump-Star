extends Node

var volume = -10

var _current_world: World
var _next_world: World

var game_soundtrack: AudioStreamPlayer
var button_select_sound: AudioStreamPlayer

var player_properties: PlayerProperties = PlayerProperties.new()

@onready var worlds: Array[World] = [
	load("res://resources/worlds/World_1.tres"),
	load("res://resources/worlds/World_2.tres"),
	load("res://resources/worlds/World_3.tres"),
]

func _ready():
	load_game()
	var button_stream = load("res://assets/sounds/bing_wa_wa_sound.wav")
	var soundtrack_stream = load("res://assets/sounds/Vitory_Awaits.ogg")
	
	# Game Soundtrack
	game_soundtrack = _setup_sound(soundtrack_stream, game_soundtrack)
	game_soundtrack.autoplay = true
	add_child(game_soundtrack)
	
	# Button Sound
	button_select_sound = _setup_sound(button_stream, button_select_sound)
	add_child(button_select_sound)
	
	game_soundtrack.finished.connect(_on_soundtrack_finished)
	
func _setup_sound(audio_stream, audio_player) -> AudioStreamPlayer:
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = audio_stream
	audio_player.volume_db = volume
	
	return audio_player


func select_world(scene: PackedScene):
	for i in range(len(worlds)):
		if worlds[i].world_scene == scene:
			_current_world = worlds[i]
			if i < len(worlds) - 1:
				_next_world = worlds[i+1]
			else:
				_next_world = null

func select_next_world() -> World:
	if _next_world == null:
		print("Error there is no next world to go to")
		return null
	
	# Find next world in list if any
	for i in range(len(worlds)):
		if worlds[i] == _next_world:
			_next_world.status = World.LockState.UNLOCKED
			_current_world = _next_world
			if i < (len(worlds) - 1):
				_next_world = worlds[i+1]
			else:
				_next_world = null
				
	return _current_world
	
func load_game():
	if not FileAccess.file_exists("res://savegame.save"):
		return
	
	# Read each line in file
	var save_game_file = FileAccess.open("res://savegame.save", FileAccess.READ)
	while save_game_file.get_position() < save_game_file.get_length():
		var json_string = save_game_file.get_line()
		
		# Helper class
		var json: JSON = JSON.new()
		
		# Error check parse
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var data = json.data
		print(data)

func save_game():
	var save_game_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(worlds)
	save_game_file.store_line(json_string)

func fade_in(node, time=100):
	node.modulate.a = 0
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(node, "modulate:a", 255, time)
	fade_tween.play()
	
	await fade_tween.finished
	
func fade_out(node, time=0.5):
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(node, "modulate", Color(0, 0, 0), time)
	fade_tween.play()
	
	await fade_tween.finished
	
func play_btn_sound():
	button_select_sound.play()
	await button_select_sound.finished

func _notification(what):
	if what == 1006:
		save_game()
	
func _on_soundtrack_finished():
	game_soundtrack.play()
